package com.journaldev.elasticsearch.config;

import java.util.concurrent.ScheduledFuture;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.scheduling.support.CronTrigger;
import com.journaldev.elasticsearch.service.EsLogCollectService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
@EnableScheduling
public class EsSchedulerConfig implements SchedulingConfigurer {

    @Autowired
    private EsLogCollectService esLogCollectService;

    private static final int POOL_SIZE = 10;

    // By default, all the @Scheduled tasks are executed in a default thread pool of
    // size one created by Spring.
    @Override
    public void configureTasks(ScheduledTaskRegistrar scheduledTaskRegistrar) {
        ThreadPoolTaskScheduler threadPoolTaskScheduler = new ThreadPoolTaskScheduler();
        threadPoolTaskScheduler.setPoolSize(POOL_SIZE);
        threadPoolTaskScheduler.setThreadNamePrefix("oms-scheduled-task-pool-");
        threadPoolTaskScheduler.initialize();
        scheduledTaskRegistrar.setTaskScheduler(threadPoolTaskScheduler);
    }

    @Bean
    public TaskScheduler taskScheduler() {
        return new ThreadPoolTaskScheduler();
    }


    private Runnable executeInsertEsHitLogging() {
        return () -> esLogCollectService.insertEsHitLog();
    }

    @Bean
    public ScheduledFuture<?> scheduledFuture(@Value("${ES.LOGS.OMS.COLLECT.CRON}") String cronExpressStr) {
        log.info("cronExpressStr===================================>{}", cronExpressStr);
        return taskScheduler().schedule(executeInsertEsHitLogging(), new CronTrigger(cronExpressStr));
    }
}
