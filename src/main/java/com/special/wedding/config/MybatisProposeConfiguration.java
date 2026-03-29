package com.special.wedding.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;

/**
 * Spring Boot 4 환경에서 MyBatis 자동설정이 스킵되는 경우를 대비해
 * SqlSessionFactory + 매퍼 스캔을 명시적으로 등록합니다.
 */
@Configuration
@MapperScan(basePackages = "com.special.wedding.propose.mapper", sqlSessionFactoryRef = "sqlSessionFactory")
public class MybatisProposeConfiguration {

	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
		SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		factoryBean.setDataSource(dataSource);
		factoryBean.setMapperLocations(
			new PathMatchingResourcePatternResolver().getResources("classpath*:mapper/**/*.xml"));

		org.apache.ibatis.session.Configuration mybatisCfg = new org.apache.ibatis.session.Configuration();
		mybatisCfg.setMapUnderscoreToCamelCase(true);
		factoryBean.setConfiguration(mybatisCfg);

		return factoryBean.getObject();
	}
}
