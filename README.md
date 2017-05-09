# Worm Segmenter Spark
Running the Worm Segmenter on Spark cluster.

### Files Description
1. **install_scripts.sh**: Script for installing all the required applications
2. **openCV_scripts.sh**: Script for installing openCV libraries


### Installation and execution of WormSegmenter application on Spark

This document provides the details about how to install the required application files, change configurations 
and run the application.

## Java Application:

	a. Creating the header file for JNI
		1. Start Eclipse and imnport the java project WormSegmenter.
		2. From the menu select Run>External Tools>External Tools Configurations… 
		3. Highlight Program in the list in the left pane. Press the New button. Enter Name as "javah - C Header and Stub File Generator"
		4. For the Location browse to locate javah.exe in the JDK installation folder (will be something like /usr/lib/jvm/java-1.8.0/bin/javah)
		5. Enter Working Directory as: ${project_loc}/bin/
		   Enter Arguments as -jni ${java_type_name}
		   Click Apply
		6. Switch to the Common tab. Select the checkbox next to External Tools under Display in favourites menu.
		7. Click Apply. Click Close
		8. Deselect Build Automatically from Project Menu
		9. In the Package Explorer right click project name and select Build Project
		10. In the Package Explorer highlight Test.java
			From the menu select Run>External Tools>1 javah - C Header and Stub File Generator
		11. Now the header file will be created in folder /path/to/paroject/bin/
		12. Create a new source folder inside project as "natives". Copy the header file to this location.

	b. Creating jar
		1. Select project name from left pane in eclipse and right click to select build project.
		2. Select project name from left pane in eclipse and right click to select export.
		3. From the list select Jar->Runnable Jar. Click next.
		4. Provide name and location for the Jar and click finish.

    c. Copying Static library files
        1. Copy the C++ static library file "Test.so" to folder location "/home/ec2-user/temp/"


## Hadoop:

	1. Login to the master node. Using FileZilla or scp tools copy the following scripts on the root location.
			a. install_scripts.sh
			b. openCV_scripts.sh

	2. After upload, make the scripts executable by the following commands.
			$ sudo chmod 750 install_scripts.sh
			$ sudo chmod 750 openCV_scripts.sh

	3. Now run the uploaded scripts with the following command. If the scripts prompts for input enter 'y' or 'yes'
			$ ./install_scripts.sh
			$ ./openCV_scripts.sh

	4. After successful execution of the script, it would have setup the Hadoop and Spark environment on the instance.

	5. Generate the public/private RSA keys for allowing the master to access itself through SSH. Run the following command
				$ ssh-keygen
	
	6.	The key will be generated and stored in the file “id_ras.pub”. Now copy the generated key from the file to the 
		“authorized_keys”

	7. Create "config" file in the folder "~/.ssh/" and add the following line
				StrictHostKeyCheck=no
		And change the permissions to 600 using chmod.

	8. Update the following Hadoop configuration files based on the single-node and multi-node cluster setup.
			a. core-site.xml
			b. hdfs-site.xml
			c. mapred-site.xml
			d. yarn-site.xml
			e. masters
			f. slaves

	9. Create a folder "tmp" at the location "~/".

	10. First run the following command to format the namenode HDFS system.
			$ hdfs dfs namenode -format 

	11. Now start the master and cluster nodes
			$ start-dfs.sh

	12. Then start the resource manager
			$ start-yarn.sh

	13. Check if all the process are running using the command 
			$ jps

	14. Copy the input data file to HDFS using the following command.
			$ hdfs dfs -mkdir data
			$ hdfs dfs -copyFromLocal ~/data/* /data
			$ hdfs dfs -copyFromLocal ~/input.txt /

	19. To Stop the services
			$ stop-dfs.sh
			$ stop-yarn.sh


## Spark (standalone mode):

	1. If you have already installed as instructed in the above instructions then continue to Step-2 or else go through the  
	   Steps 1 to 10 in the Hadoop installation instructions.

	2. After updating the configuration files, we can start the spark master at the directory "spark/sbin/" by executing the 
	   folowing command.
	   		$ start-master.sh

	3. Start the slave 
			$ start-slave.sh

		[NOTE: If the master and slaves have started properly, you can check it at the following link,
				http://<_public_dns_of_instance_>:8080]

	4. Now start the spark application at the folder "spark/bin/" using the following command.
			$ ./spark-submit --class com.zee.spark.Test 
							 --master local[1] ~/appJNI.jar 
							 hdfs://<_public_dns_of_instance_>:9000/data/ 
							 hdfs://<_public_dns_of_instance_>:9000/input.txt 
							 hdfs://<_public_dns_of_instance_>/output

	5. When the application is running you can track the job progress on the following link.
			http://<_public_dns_of_instance_>:4040

	6. After the application executes successfully Copy the output data file from HDFS to local using the following command.
			$ hdfs dfs -copyToLocal /ouput <ouput_file_location>

	7. Stop the master and slave processess at the directory "spark/sbin/" using the commands
			$ ./stop-master.sh
			$ ./stop-slave.sh


## Spark (Cluster mode):

	1. Logon to any AWS instance and go through the Step - 1 to Step - 3 in the Hadoop installation instructions.

	2. After updating the configuration files, we can start the spark master at the directory "spark/sbin/" by executing the 
	   folowing command.
	   		$ start-master.sh

	3. Start the slave 
			$ start-slave.sh

		[NOTE: If the master and slaves have started properly, you can check it at the following link,
				http://<_public_dns_of_instance_>:8080]

	4. Now start the spark application at the folder "spark/bin/" using the following command.
			$ ./spark-submit --class com.zee.spark.Test 
							 --master spark://<_public_dns_of_instance_>:7077 ~/appJNI.jar 
							 hdfs://<_public_dns_of_instance_>:9000/data/ 
							 hdfs://<_public_dns_of_instance_>:9000/input.txt 
							 hdfs://<_public_dns_of_instance_>:9000/output


	5. After the application executes successfully Copy tthe output data file from HDFS to local using the following command.
	   		$ ./hadoop dfs -copyToLocal /ouput <ouput_file_location>

	6. Stop the master and slave processess at the directory "spark/sbin/" using the commands
			$ ./stop-master.sh
			$ ./stop-slave.sh
	
