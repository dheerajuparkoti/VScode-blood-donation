<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('reg_donors', function (Blueprint $table) {
           
            $table->bigIncrements('donorId');   
            $table ->string('profilePic')->default('NA');       
            $table->string('fullName');
            $table->date('dob');
            $table->string('gender');
            $table->string('bloodGroup');
            $table->integer('province');
            $table->string('district');
            $table->string('localLevel');
            $table->integer('wardNo')->max(2);
            $table->string('phone')->min(10)->unique();
            $table->string('email')->nullable();
            $table->string('canDonate')->default('Yes');                              
            $table -> unsignedBigInteger('userId');//foreign key from reg_users table
            $table->timestamps();
             // Foreign key constraint          
             $table->foreign('userId')->references('id')->on('reg_users');


        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reg_donors');
    }
};
