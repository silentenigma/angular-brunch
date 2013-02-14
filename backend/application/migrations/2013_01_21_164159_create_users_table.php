<?php

class Create_Users_Table {    

	public function up()
    {
		Schema::create('users', function($table) {

			$table->increments('id');
            $table->string('name', 50);
            $table->string('email')->unique();
            $table->string('password', 64);
            $table->string('reset_token', 40)
            $table->date('reset_at')
            $table->timestamps();
	});

    }    

	public function down()
    {
		Schema::drop('users');

    }

}