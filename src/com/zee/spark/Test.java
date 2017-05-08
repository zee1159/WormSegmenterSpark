package com.zee.spark;

import org.apache.spark.sql.SparkSession;

import java.util.Arrays;
import java.util.regex.Pattern;

import org.apache.spark.api.java.*; 

public class Test {
	public static String path;
	
	private static final Pattern NEWLINE = Pattern.compile("\n");
	
	public native String run(String path, String fname);
	
	static{
		System.load("/home/ec2-user/temp/Test.so");
	}

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		SparkSession spark = SparkSession
							 .builder()
							 .appName("WormSegmenter")
							 .getOrCreate();
		
		path = args[0];
		
		//JavaSparkContext jsc = new JavaSparkContext(spark.sparkContext());
		
		JavaRDD<String> lines = spark.read().textFile(args[1]).javaRDD();
		//JavaRDD<String> data = jsc.textFile(args[1]);
		
		JavaRDD<String> img = lines.flatMap(s->Arrays.asList(NEWLINE.split(s)).iterator());
		
		JavaRDD<String> compute = img.map(s->(compute(s)));
		
		compute.saveAsTextFile(args[2]);
		//jsc.close();
		spark.stop();
	}

	public static String compute(String s) {
		// TODO Auto-generated method stub
		Test app = new Test();
		//String in_path = path + "/data/";
		
		String res = app.run(path, s);
		
		return res;
	}
}
