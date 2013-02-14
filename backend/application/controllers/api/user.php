<?php

class Api_User_Controller extends Base_Controller{

	//
	// register new user
	//
	public function action_register()
	{
		$data = Input::json();

		if(!(isset($data->email) && isset($data->username) && isset($data->password)) )
			return Resp::exec(Resp::invalid_request);


		$email = User::where_email($data->email)->first();
		if($email) 
			return Resp::exec(Resp::user_exist);


		$user = new User;
		$user->email = $data->email;
		$user->password = Hash::make($data->password);
		$user->name= $data->username;

		// success so log in and return user data
		if($user->save()) {

			Auth::login($user->id);
			return Resp::exec(Resp::ok, User::authUserData());

		}

		return Response::error(500);		
	}

	//
	// update user settings
	//
	public function action_update($id)
	{

	}

	//
	// delete exist and logged user
	//
	public function action_delete($id)
	{

	}

	//
	// check if there is a user with an email adress
	//
	public function action_unique()
	{	

		$data = $_POST['data'];

		if (!isset($data)) return Resp::exec(Resp::invalid_request);

		$email = User::where_email($data)->first();

		if ($email) return false;
		else return true;
	}

	//
	// remind user password
	//
	public function action_forgot()
	{
		$data = Input::json();
		if (!isset($data->email))
			return Resp::exec(Resp::invalid_request);

		$user = User::where_email($data->email)->first();


		if ($user)
		{ 
			$user->reset_token = Str::random(40);
			$user->reset_at = date("Y-m-d H:i:s");
			$user->save();

			$url = URL::base()."/#/reset/$user->id/$user->reset_token";

			$message = Message::instance();
			

			$message->to('robertsadowski@outlook.com');	
			$message->from('brightophidia@gmail.com', 'Do');
	    	$message->subject('Reset password from Do');
	    	$message->body('view: email');
	    	$message->body->token_link = $url;
	    	$message->html(true);
	    	$message->send();
			

			return Resp::exec(Resp::ok, $message);
		}

		return Resp::exec(Resp::user_not_exist);
	}

	public function action_reset()
	{
		$data = Input::json();

		if (!(isset($data->id) && isset($data->password) && isset($data->token)))
			return Resp::exec(Resp::invalid_request);

		$user = User::find($data->id);

		if ($user) {
		 
			// check is reset time is valid 24 h
			$reset_at = new DateTime($user->reset_at); 
			$interval = $reset_at->diff(new DateTime());
			$reset_expired = (intval($interval->format("%d")) <= 1 ) ? false: true;

			if (!$reset_expired  && $user->reset_token === $data->token )
			{
				$user->reset_token = Str::random(40);
				$user->password = Hash::make($data->password);

				$user->save();
				return Resp::exec(Resp::ok);

			}	

		}
		
		return Resp::exec(Resp::reset_link_expired);
		
	}


}