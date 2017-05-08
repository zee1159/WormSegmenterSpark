package com.zee.spark;

import org.apache.spark.sql.SparkSession;
import org.apache.spark.api.java.*; 

public class Test {
	public static String path;
	
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
		
		JavaSparkContext jsc = new JavaSparkContext(spark.sparkContext());
		
		JavaRDD<String> data = jsc.textFile(args[1]);
		
		JavaRDD<String> compute = data.map(s->(compute(s)));
		
		compute.saveAsTextFile(args[2]);
	}

	private static String compute(String s) {
		// TODO Auto-generated method stub
		Test app = new Test();
		//String in_path = path + "/data/";
		
		String res = app.run(path, s);
		
		return res;
	}
}
