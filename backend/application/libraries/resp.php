<?php

class RespCode{

	const ok = 0;

	const no_auth = 101;
	const invalid_token = 102;
	const invalid_credentials = 103;

	const invalid_request = 404;
}

class Resp extends Response{

	const ok = 0;

	const invalid_request = 1;

	const authorization_rquired = 101;
	const invalid_token = 102;
	const invalid_credentials = 103;
	const user_exist = 104;
	const user_not_exist = 105;
	const reset_link_expired = 106;

	const page_no_found = 404;

   	public static function exec($code, $response = null)
   	{
   		return Response::json(array(
			'code' => $code,
			'response' => $response
			)
		);
   	}

}