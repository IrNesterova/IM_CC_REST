package portfolio.example.im_cc.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * RabbitMQ is optional: its beans exist only when RABBITMQ_HOST is set. Without it the app
 * never tries to reach a broker, and bug reports are saved straight to the database.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.METHOD})
@ConditionalOnExpression("!'${RABBITMQ_HOST:}'.isBlank()")
public @interface ConditionalOnRabbitMq {
}
