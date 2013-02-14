<?php

class Api_Auth_Controller extends Base_Controller {



	public function action_get()
	{

		if (Auth::check())
			return Resp::exec(RespCode::ok, User::authUserData());

		return Resp::exec(RespCode::ok, array('token' => ""));
	}

	public function action_login()
	{
		sleep(3);
		
		if(Auth::check()) return Resp::exec(Resp::ok, User::authUserData());

		$data = Input::json();
	
		if( isset($data->email) && isset($data->password))
		{
			$credentials = array('username' => $data->email, 'password' => $data->password);

			if (Auth::attempt($credentials))
			{
     			return Resp::exec(RespCode::ok, User::authUserData());
			}
		}

		return Resp::exec(Resp::invalid_credentials);
	}

	public function action_logout()
	{
		Session::forget('token');
		Auth::logout();
		return Resp::exec(RespCode::ok, array());
	}

}
