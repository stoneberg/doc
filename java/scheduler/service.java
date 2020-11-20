​
        package com.journaldev.elasticsearch.service;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ScheduledFuture;
import javax.management.RuntimeErrorException;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.BucketOrder;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.journaldev.elasticsearch.mapper.EsLogCollectMapper;
import com.journaldev.elasticsearch.model.EsHitLog;
import com.journaldev.elasticsearch.model.EsJobLog;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EsLogCollectService {
    private static final String INDEX = "logs";
    private static final String TYPE = "oms";
    private static final String COMPLETED = "COMPLETED";
    private static final String FAILED = "FAILED";


    private static final DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private TaskScheduler taskScheduler;

    @Autowired
    private ScheduledFuture<?> scheduledFuture;
    @Autowired
    private EsLogCollectMapper esLogCollectMapper;

    @Autowired
    private RestHighLevelClient restHighLevelClient;


    public List<EsHitLog> searchEsOmsLogs() throws IOException {
        log.debug("SearchResponse==================>}");

        // select userid, location, count(*) from table order by userid, location order by count(*)
        SearchResponse response = restHighLevelClient.search(new SearchRequest(INDEX).types(TYPE)
                .source(new SearchSourceBuilder()
                        .query(QueryBuilders.rangeQuery("created")
                                .from("2017-10-01T00:00:00")
                                .to("2018-01-31T00:00:00")
                                .includeLower(true) // x <= y
                                .includeUpper(false)) // y < z
                        .aggregation(AggregationBuilders.terms("by_user")
                                .field("userid.keyword")
                                .order(BucketOrder.key(true))
                                .size(10000)
                                .subAggregation(AggregationBuilders.terms("by_location")
                                        .field("location.keyword")
                                        .order(BucketOrder.count(true))
                                        .size(10000))
                        )//jobEnd of aggregation

                ) //jobEnd of source

        ); //jobEnd of search

        log.info("###################################################################################");

        List<EsHitLog> result = new ArrayList<>();

        log.info("Query results:");

        ((Terms) response.getAggregations().get("by_user")).getBuckets().forEach(useridBk -> {

            EsHitLog esLog = new EsHitLog();
            esLog.setUserid(useridBk.getKeyAsString());

            ((Terms) useridBk.getAggregations().get("by_location")).getBuckets().forEach(locationBk -> {

                esLog.setLocation(locationBk.getKeyAsString());
                esLog.setDocCount(locationBk.getDocCount());

            });

            result.add(esLog);

        });

        log.info(">>>>>>>>>>>>>{}", result);
        log.info("###################################################################################");

        return result;
    }


    //@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class) 
    public void insertEsHitLog() {

        // jobStart time


        try {


            int count = 0;
            EsJobLog completeLog = new EsJobLog();
            completeLog.setStartTime(LocalDateTime.now());
            log.info("================================================================");

            List<EsHitLog> esHitLogList = this.searchEsOmsLogs();

            for (EsHitLog esHitLog : esHitLogList) {
                count += esLogCollectMapper.insertEsHitLog(esHitLog);
            }

            completeLog.setEndTime(LocalDateTime.now());

            log.info("count======{}", count);


            // if count > 0 logging OK
            if (count > 0) {
                completeLog.setStatus(COMPLETED);
                esLogCollectMapper.insertEsJobLog(completeLog);
                //throw new RuntimeException("customized exception");
            }

        } catch (Exception e) {
            log.debug("insertEsHitLog[ERROR]======>{}", e.getMessage());
            insertEsJobFailLog();
        }

    }


    public void insertEsJobFailLog() {
        EsJobLog failLog = new EsJobLog(LocalDateTime.now(), LocalDateTime.now(), FAILED);
        esLogCollectMapper.insertEsJobLog(failLog);
    }


    public void stopEsLogCollect() {
        log.info("@@@@@ Stop EsLog Collect....................");
        scheduledFuture.cancel(false);
    }


    public void restartEsLogCollect(String cronExpressionStr) {
        log.info("@@@@@ Restart EsLog Collect....................");
        if (scheduledFuture != null) scheduledFuture.cancel(false);
        scheduledFuture = taskScheduler.schedule(executeInsertEsHitLogging(), new CronTrigger(cronExpressionStr));
    }

    private Runnable executeInsertEsHitLogging() {
        return () -> insertEsHitLog();
    }

}