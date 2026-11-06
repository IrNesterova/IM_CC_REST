package portfolio.example.im_cc.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.JacksonJsonMessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConditionalOnRabbitMq
public class RabbitMQConfig {

    public static final String BUG_REPORT_QUEUE       = "bug-report.queue";
    public static final String BUG_REPORT_EXCHANGE    = "bug-report.exchange";
    public static final String BUG_REPORT_ROUTING_KEY = "bug-report";

    @Bean
    public Queue bugReportQueue() {
        return QueueBuilder.durable(BUG_REPORT_QUEUE).build();
    }

    @Bean
    public DirectExchange bugReportExchange() {
        return new DirectExchange(BUG_REPORT_EXCHANGE);
    }

    @Bean
    public Binding bugReportBinding(Queue bugReportQueue, DirectExchange bugReportExchange) {
        return BindingBuilder.bind(bugReportQueue).to(bugReportExchange).with(BUG_REPORT_ROUTING_KEY);
    }

    @Bean
    public JacksonJsonMessageConverter messageConverter() {
        return new JacksonJsonMessageConverter();
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory,
                                         JacksonJsonMessageConverter messageConverter) {
        RabbitTemplate template = new RabbitTemplate(connectionFactory);
        template.setMessageConverter(messageConverter);
        return template;
    }

    @Bean
    public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory(
            ConnectionFactory connectionFactory,
            JacksonJsonMessageConverter messageConverter) {
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setMessageConverter(messageConverter);
        return factory;
    }
}
