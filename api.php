<?php

class Response {
	/**
	 * 鎸塲son鏂瑰紡杈撳嚭閫氫俊鏁版嵁
	 * @param  integer $code    鐘舵€佺爜
	 * @param  string $message 鎻愮ず淇℃伅
	 * @param  array  $data    鏁版嵁
	 * @return string
	 */
	public static function json($code, $message = '', $data = array()) {

		if (!is_numeric($code)) {
			return '';
		}

		$result = array(
			'code'    => $code,
			'message' => $message,
			'data'    => $data 
			);

		return json_encode($result);
		exit;
	}
}
