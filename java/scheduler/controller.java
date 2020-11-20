​package com.journaldev.elasticsearch.controller;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.journaldev.elasticsearch.service.EsLogCollectService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/es")
public class EsLogCollectController {
    @Autowired
    private EsLogCollectService esLogCollectService;

    @Value("${ES.LOGS.OMS.COLLECT.CRON}")
    private String logCollectCronExpression;

    // http://localhost:8080/es/collect/logs/oms
    @GetMapping("/collect/logs/oms")
    public void searchLogAndCollect() throws IOException {
        log.info("searchOmsLogs======>");
        esLogCollectService.insertEsHitLog();
    }

    // http://localhost:8080/es/collect/logs/oms/start/0%20*%20*%20*%20*%20%3F [0 * * * * ?]
    @RequestMapping("/collect/logs/oms/start/{cronExpressionStr}")
    ResponseEntity<String> start(@PathVariable("cronExpressionStr") String cronExpressionStr) {
        esLogCollectService.restartEsLogCollect(cronExpressionStr);
        return new ResponseEntity<>("ElasticSearch 고객 로그 수집 배치가 {" + cronExpressionStr + "} 설정으로 시작됩니다.", HttpStatus.OK);
    }

    // http://localhost:8080/es/collect/logs/oms/stop
    @RequestMapping("/collect/logs/oms/stop")
    ResponseEntity<String> stop() {
        esLogCollectService.stopEsLogCollect();
        return new ResponseEntity<>("ElasticSearch 고객 로그 수집 배치가 종료됩니다.", HttpStatus.OK);
    }

}