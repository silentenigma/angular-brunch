<?php

class Api_Task_Controller extends Base_Controller {


	public function action_get()
	{
		return Resp::exec(RespCode::ok, array('task_id' => "1"));
	}

}
