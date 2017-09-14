<?php

/**
 * 单例模式
 */
 class Db {
	//用于保存类的实例化的静态成员变量
	static private $_instance;
	static private $_connectSource;
	private $_dbConfig = array(
		'host'     =>'127.0.0.1',
		'user'     =>'root',
		'password' =>'123456',
		'database' =>'raspberry'
		);

	/**
	 * 构造函数需要标记为 private（防止外部使用new操作符创建对象）
	 * 单例不能在其他类中实例化，只能被自身实例化
	 */
	private function __construct() {

	}
    /* 拥有一个访问这个实例的公共的静态方法*/
	static public function getInstance() {
		/* 判断类是否已经实例化
		  instanceof 运算符是用来在运行时指出对象是否是特定类的一个实例
		 */
		if (!self::$_instance instanceof self) {
			self::$_instance = new self();
		}
		return self::$_instance;
	}

	public function connect() {
		if(!self::$_connectSource) {
			self::$_connectSource = mysqli_connect($this->_dbConfig['host'], $this->_dbConfig['user'], $this->_dbConfig['password']);

			if (!self::$_connectSource) {
				//抛出异常
				throw new Exception('MySQL connect error'.mysql_error(), 1);
				//die('MySQL connect error'.mysql_error());
			}

			mysqli_select_db(self::$_connectSource, $this->_dbConfig['database']);
			mysqli_query(self::$_connectSource, "set names UTF8");
		}
		return self::$_connectSource;
	}
}

