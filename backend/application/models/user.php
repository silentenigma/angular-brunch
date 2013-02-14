<?php

class User extends Eloquent 
{
	public static function authUserData()
	{
		$user = Auth::user();
		$user = $user->to_array();
		unset($user['password']);
		unset($user['reset_token']);
		unset($user['reset_at']);

		if(!Session::has('token')){

			Session::put('token', Str::random(40));
		}

		$user['token'] = Session::get('token');
	
		return $user;
	}
}