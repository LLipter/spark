# Apache Spark™ - Unified Analytics Engine for Big Data


![spark-logo](assets/spark-logo-trademark.png)


# Abstract

Spark is a general-purpose data processing engine that is suitable for use in a wide range of circumstances providing interfaces in a variety of programming languages including **Scala**, **Java** and **Python**. Application developers and data scientists incorporate Spark into their applications to rapidly query, analyze, and transform data at scale. Tasks most frequently associated with Spark include interactive queries across large data sets, processing of streaming data from sensors or financial systems, and machine learning tasks. As of 21-09-2018, the project has over 22,000 commits, 1285 contributors, 75 releases and has been forked over 16,000 times.


# Table of Contents

1. Overview
2. stakeholders
3. Deployment view
4. Context view
5. Architecture(Development view)
6. Evolution perspective
7. Summary
8. References


# 1 Overview

## 1.1 Introduction

Apache Spark is a fast and general-purpose cluster computing system. It provides high-level APIs in Java, Scala, Python and R, and an optimized engine that supports general execution graphs. It also supports a rich set of higher-level tools including Spark SQL for SQL and structured data processing, MLlib for machine learning, GraphX for graph processing, and Spark Streaming.


## 1.2 Spark DataType

RDD (Resilient Distributed Dataset), which is the most basic data abstraction in Spark. It represents aset that is immutable, partitioned, and whose elements can be calculated in parallel. RDD has the characteristics of data flow model: automatic fault tolerance, location-aware scheduling, and scalability. RDD allows users to explicitly cache working sets in memory while performing multiple queries, and subsequent queries can reuse working sets, which greatly increases query speed.

By introducing the concept of RDD, Spark provides efficient big data operations without incurs substantial overheads due to data replication, disk I/O, and serialization, which can dominate application execution times. In addition, RDDs are fault-tolerant, parallel data structures that let users explicitly persist intermediate results in memory, control their partitioning to optimize data placement, and manipulate them using a rich set of operators.

After evaluating RDDs and Spark through both microbenchmarks and measurements of user applications, we find that Spark is up to 20× faster than **Hadoop** for iterative applications, speeds up a real-world data analytics report by 40×, and can be used interactively to scan a 1 TB dataset with 5–7s latency.

## 1.3 Security

Spark currently supports authentication via a shared secret. Authentication can be configured to be on via the `spark.authenticate` configuration parameter. This parameter controls whether the Spark communication protocols do authentication using the shared secret. This authentication is a basic handshake to make sure both sides have the same shared secret and are allowed to communicate. If the shared secret is not identical they will not be allowed to communicate. The shared secret is created as follows:

- For Spark on YARN deployments, configuring `spark.authenticate` to true will automatically handle generating and distributing the shared secret. Each application will use a unique shared secret.
- For other types of Spark deployments, the Spark parameter `spark.authenticate.secret` should be configured on each of the nodes. This secret will be used by all the Master/Workers and applications.

## 1.4 Applicable scenario

At present, big data processing scenarios have the following types:

1. Complex Batch Data Processing focuses on the ability to process massive Data. As for the tolerable Processing speed, the usual time may be from dozens of minutes to several hours.

2. Interactive Query based on historical data, which usually takes between tens of seconds and tens of minutes

3. Data Processing based on real-time Data flow, usually between hundreds of milliseconds and seconds

Currently, there are mature processing frameworks for the above three scenarios. In the first case, Hadoop's MapReduce can be used for bulk mass data processing, in the second case, Impala can be used for interactive query, and in the third case, Storm distributed processing framework can be used to process real-time streaming data. All of the above three are relatively independent, each of which has a relatively high maintenance cost, and the emergence of Spark can satisfy the requirements above.

Based on the above analysis, the Spark scenario is summarized as follows:

- Spark is a memory based iterative computing framework for applications that require multiple manipulation of a particular dataset. The more repeated operations are required, the greater the amount of data to be read and the greater the benefit, and the smaller the amount of data but the more intensive the calculation, the less benefit

- Because of RDD's features, Spark doesn't apply to applications that are asynchronous and fine-grained update states, such as the storage of web services or incremental web crawlers and indexes. It's just not a good model for that incremental change

- The statistical analysis whose amount of data is not particularly large, but requires real-time 

## 1.5 Technical Platform
### 1.5.1 Running Environment
- Spark is created by Scala, it could run on JVM so we need Java7 or higher edition.
- If we use Python API, we need Python2.6+ or Python3.4+.
- Edition mapping:
Spark1.6.2--Scala2.10;
Spark2.0.0--Scala2.11;


## 1.6 Installing Spark Standalone to a Cluster

To install Spark Standalone mode, you simply place a compiled version of Spark on each node on the cluster. You can obtain pre-built versions of Spark with each release or [build it yourself](http://spark.apache.org/docs/latest/building-spark.html).

### Starting a Cluster Manually

You can start a standalone master server by executing:

`./sbin/start-master.sh`

Once started, the master will print out a spark://HOST:PORT URL for itself, which you can use to connect workers to it, or pass as the “master” argument to SparkContext. You can also find this URL on the master’s web UI, which is http://localhost:8080 by default.

Similarly, you can start one or more workers and connect them to the master via:

`./sbin/start-slave.sh <master-spark-URL>`

Once you have started a worker, look at the master’s web UI (http://localhost:8080 by default). You should see the new node listed there, along with its number of CPUs and memory (minus one gigabyte left for the OS).


# 2 stakeholders

## 2.1 Major contributors
the major contrubitors who developed spark
are:

- Reynold Xin
- Matei Zaharia
- Michael Armbrust
- Wenchen Fan
- Patrick Wendell
- Josh Rosen
- Tathagata Das
- Cheng Lian

![contributors](assets/contributors1.png)

![contributors](assets/contributors2.png)

And the companies below majorly contributed spark

- University of California, Berkeley
- Databricks
- Yahoo
- Intel
## 2.2 Customers and Users detail
- Currently, more than 30+ company 100+ developers are submitting code

- Cloudera, one of Hadoop's largest vendors, claims to be investing more in the Spark framework to replace Mapreduce
- Hortonworks
- MapR, a Hadoop manufacturer, has launched the Spark camp
- Apache Mahout abandons MapReduce and USES Spark as the computing platform for subsequent operators
- Hortonworks，Tecent，Yahoo，Alibaba，Youku and more company at home and abroad are using spark to replace the old framework to improve efficiency.

# 3 DeploymentView

## 3.1 Deployment methods:

### 3.1.1 Standalone
Use the resource scheduling framework that comes with spark: (not dependent on other distributed management platforms)
![standalone-view](assets/standalone.png)
Steps:
1. SparkContext connects to the Master, registers with the Master and applies for resources (CPU Core and Memory)
2. Master gets the resources on the Worker, then starts StandaloneExecutorBackend;
3. StandaloneExecutorBackend registers with SparkContext;
4. SparkContext sends the Applicaiton code to StandaloneExecutorBackend;
5. SparkContext parses the Applicaiton code, builds the DAG map, submits it to the DAG Scheduler and decomposes it into a Stage, and then submits it to the Task Scheduler in a Stage (or called TaskSet). 
6. The Task Scheduler is responsible for assigning the Task to The corresponding Worker is finally submitted to StandaloneExecutorBackend for execution;
7. StandaloneExecutorBackend will create an Executor thread pool, start executing the Task, and report to the SparkContext until the Task is completed.
8. After all Tasks are completed, SparkContext logs out to the Master and releases the resources.

### 3.1.2 Spark on Mesos
Mesos is an open source distributed resource management framework under Apache. It is called the kernel of distributed systems.
Spark is used to support multi-server simultaneous operations in the running of mesos.
Steps:
1. Submit the task to spark-mesos-dispatcher via spark-submit
2. spark-mesos-dispatcher submits to mesos master via driver and receives task ID
3. mesos master is assigned to the slave to let it perform the task
4. spark-mesos-dispatcher, query task status by task ID


### 3.1.3 Spark on YARN
Apache Hadoop YARN (Yet Another Resource Negotiator, another resource coordinator) is a new Hadoop resource manager, which is a universal resource management system.
It includes two main part:RM,AM
RM(Resource Manager):It allocates the required resource of the process. It acts as a JobTracker. It faces to the whole system;
AM(Application Manager):It manages and consoles the status and data of the process. It acts as a TaskTracker. It faces to every single process.
![yarn-veiw](assets/yarn.png)

# 5 Architecture

## High-level View

![high-level-view](assets/high-level-view.png)

The high-level view is visualized in figure above.

Looking from upper level, every **Spark** application initiate a variety of parallel operations in cluster from a **driver program**. Program driver access Spark through a **SparkContext** object. This object represents a connection to the entire cluster. By default, a SparkContext object named `sc` will be created by shell automatically.

~~~python
>>> lines = sc.textFile("README.md")
>>> lines.count()
~~~

User can define RDDs through program driver and then initiate an operation. A simple example is presented above.

As soon as the driver program receive an operation, it will try to distribute the operation over all working nodes. Each working nodes will do a part of jobs and send result back to driver program.


## Component view 

![component-view](assets/component-view.png)

The Component view is showed in the picture above.

Spark contains several components ,including Spark Core, Spark SQL, Spark Streaming, MLlib, GraphX and Cluster Manager. These components are closely related to each other, which means if we update one component, others can also be affected. By using this theory, Spark has had lots of advantages. And now, we'll introduce these components and show the relations among them.

1.Spark Core
Spark Core implements the basic functions of Spark, including task scheduling, memory management, error recovery, and storage systems. It also defines an API for RDD(resilient distribute dataset).

2.Spark SQL
Spark SQL is a package that Spark uses to manipulate structured data. With Spark SQL, we can use SQL Or the Apache Hive version of the SQL(HQL) to query data. Spark SQL supports multiple data sources, Such as Hive table, Parquet and JSON.

3.Spark Streaming
Spark Streaming is a component of Spark that provides streaming computing for real-time data. Spark Streaming provides an API for manipulating data streams and is highly responsive to the RDD API in Spark Core.

4.Spark MLlib
Spark also includes a library that provides machine learning (ML) features called MLlib. MLlib provides a variety of machine learning algorithms, including classification, regression, clustering, collaborative filtering, etc.

5.Spark GraphX
GraphX is a library for manipulating graphs that can perform parallel graph calculations.

6.Cluster Manager
Spark can efficiently scale calculations from one compute node to thousands of compute nodes.

### Layer Structure

![Layer-Structure](assets/layer-structure.png)

The Components we list above are organized in a Layer Structure. Spark Core is the basic layer which can create RDD and basic function to support the upper layer. Spark SQL, Spark Streaming, MLlib and GraphX consist the second layer, which implements most of the function of Spark. The top layer is a Cluster Master which can organize the task created by users. By using this structure, Spark is easy to learn and use. What's more, it can be deployed in different platforms and work efficiently.   

# 6 Evolution perspective

## 6.1 spark's history  

- 2018-02-28，Spark 2.3.0发布
 - 这也是 2.x 系列中的第四个版本。此版本增加了对 Structured Streaming 中的 Continuous Processing 以及全新的 Kubernetes Scheduler 后端的支持。其他主要更新包括新的 DataSource 和 Structured Streaming v2 API，以及一些 PySpark 性能增强。此外，此版本继续针对项目的可用性、稳定性进行改进，并持续润色代码。
 - 具体参见：
		- Apache Spark 2.3.0 正式发布
		- Apache Spark 2.3.0 重要特性介绍
- 2017-12-01，Spark 2.2.1发布
- 2017-10-09，Spark 2.1.2发布
- 2017-07-11，Spark 2.2.0发布
	- 这也是 2.x 系列的第三个版本。此版本移除了 Structured Streaming 的实验标记（experimental tag），意味着已可以放心在线上使用。
	- 该版本的主要更新内容主要针对的是系统的可用性、稳定性以及代码润色。包括：
		- Core 和 Spark SQL 的 API 升级和性能、稳定性改进，比如支持从 Hive metastore 2.0/2.1 中读取数据；支持解析多行的 JSON 或 CSV 文件；移除对 Java 7 的支持；移除对 Hadoop 2.5 及更早版本的支持 等
		- SparkR 针对现有的 Spark SQL 功能添加了更广泛的支持，比如 Structured Streaming 为 R 语言提供的 API ；R 语言支持完整的 Catalog API ；R 语言支持 DataFrame checkpointing 等
	- 具体参见：
		- Apache Spark 2.2.0 正式发布
		- Apache Spark 2.2.0 新特性详细介绍
- 2017-05-02，Spark 2.1.1发布
- 2016-12-28，Spark 2.1.0发布
	- 这是 2.x 版本线的第二个发行版。此发行版在为Structured Streaming进入生产环境做出了重大突破，Structured Streaming现在支持了event time watermarks了，并且支持Kafka 0.10。此外，此版本更侧重于可用性，稳定性和优雅(polish)，并解决了1200多个tickets。
- 2016-11-24，Spark 2.0.2发布
- 2016-11-07，Spark 1.6.3发布
- 2016-10-03，Spark 2.0.1发布
- 2016-07-26，Spark 2.0.0发布
	- 该版本主要更新APIs，支持SQL 2003，支持R UDF ，增强其性能。300个开发者贡献了2500补丁程序。
- 2016-06-25，Spark 1.6.2发布
- 2016-03-09，Spark 1.6.1发布
- 2016-01-04，Spark 1.6.0发布
	- 该版本含了超过1000个patches，在这里主要展示三个方面的主题：新的Dataset API，性能提升(读取Parquet 50%的性能提升，自动内存管理，streaming state management十倍的性能提升），以及大量新的机器学习和统计分析算法。
	- 在Spark1.3.0引入DataFrame，它可以提供high-level functions让Spark更好的处理数据结构和计算。这让Catalyst optimizer 和Tungsten execution engine自动加速大数据分析。发布DataFrame之后开发者收到了很多反馈，其中一个主要的是大家反映缺乏编译时类型安全。为了解决这个问题，Spark采用新的Dataset API (DataFrame API的类型扩展)。Dataset API扩展DataFrame API支持静态类型和运行已经存在的Scala或Java语言的用户自定义函数。对比传统的RDD API，Dataset API提供更好的内存管理，特别是在长任务中有更好的性能提升。
- 2015-11-02，Spark 1.5.2发布
- 2015-10-06，Spark 1.5.1发布
- 2015-09-09，Spark 1.5.0发布
	- Spark 1.5.0是1.x线上的第6个发行版。这个版本共处理了来自230+contributors和80+机构的1400+个patches。
	- Spark 1.5的许多改变都是围绕在提升Spark的性能、可用性以及操作稳定性。
	- Spark 1.5.0焦点在Tungsten项目，它主要是通过对低层次的组建进行优化从而提升Spark的性能。
	- Spark 1.5版本为Streaming增加了operational特性，比如支持backpressure。另外比较重要的更新就是新增加了一些机器学习算法和工具，并扩展了Spark R的相关API。
- 2015-07-15，Spark 1.4.1发布
	- DataFrame API及Streaming，Python，SQL和MLlib的bug修复
- 2015-06-11，Spark 1.4.0发布
	- 该版本将 R API 引入 Spark，同时提升了 Spark 的核心引擎和 MLlib ，以及 Spark Streaming 的可用性。
- 2015-03-13，Spark 1.3.0发布
	- 该版本发布的最大亮点是新引入的DataFrame API，对于结构型的DataSet，它提供了更方便更强大的操作运算。除了DataFrame之外，还值得关注的一点是Spark SQL成为了正式版本，这意味着它将更加的稳定，更加的全面。
- 2015-02-09，Spark 1.2.1发布
	- Spark核心API及Streaming，Python，SQL，GraphX和MLlib的bug修复
- 2014-12-18，Spark 1.2.0发布
- 2014-11-26，Spark 1.1.1发布
	- Spark核心API及Streaming，Python，SQL，GraphX和MLlib的bug修复
- 2014-09-11，Spark 1.1.0发布
- 2014-08-05，Spark 1.0.2发布
	- Spark核心API及Streaming，Python，MLlib的bug修复
- 2014-07-11，Spark 1.0.1发布
	- 增加了Spark SQL的新特性和堆JSON数据的支持等
- 2014-05-30，Spark 1.0.0发布
	- 增加了Spark SQL、MLlib、GraphX和Spark Streaming都增加了新特性并进行了优化。Spark核心引擎还增加了对安全YARN集群的支持
- 2014-04-09，Spark 0.9.1发布
	- 增加使用YARN的稳定性，改进Scala和Python API的奇偶性
- 2014-02-02，Spark 0.9.0发布
	- 增加了GraphX，机器学习新特性，流式计算新特性，核心引擎优化（外部聚合、加强对YARN的支持）等
- 2013-12-19，Spark 0.8.1发布
	- 支持Scala 2.9，YARN 2.2，Standalone部署模式下调度的高可用性，shuffle的优化等
- 2013-09-25，Spark 0.8.0发布
	- 一些新功能及可用性改进
- 2013-07-16，Spark 0.7.3发布
	- 一些bug的解决，更新Spark Streaming API等
- 2013-06-21，Spark接受进入Apache孵化器
- 2013-06-02，Spark 0.7.2发布
- 2013-02-27，Spark 0.7.0发布
	- 增加了更多关键特性，例如：Python API、Spark Streaming的alpha版本等
- 2013-02-07，Spark 0.6.2发布
	- 解决了一些bug，并增强了系统的可用性
- 2012-10-15，Spark 0.6.0发布
	- 大范围的性能改进，增加了一些新特性，并对Standalone部署模式进行了简化
- 2010 ，Spark正式对外开源
- 2009 ，Spark诞生于UCBerkeley的AMP实验室

### changes required

#### core

#### IDE
