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
        Schema::create('request_bloods', function (Blueprint $table) {
            /*
            $table->id(); // first default it makes id as primary key 

            $table->renameColumn('id', 'request_id');// first renaming
            $table->primary('request_id');// and making primary key named as request_id
*/
            $table->bigIncrements('requestId'); 
            $table->string('fullName');
            $table->string('bloodGroup');
            $table->unsignedInteger('requiredPint');
            $table->text('caseDetail');
            $table->string('contactPersonName');
            $table->string('contactNo');
            $table->date('requiredDate');
            $table->time('requiredTime');
            $table->string('hospitalName');
            $table->string('province')->max(1);;
            $table->string('district');
            $table->string('localLevel');
            $table->integer('wardNo')->max(2);        
            $table -> unsignedBigInteger('doId');//foreign key from reg_donors table
            $table->timestamps();
             // Foreign key constraint
             $table->foreign('doId')->references('donorId')->on('reg_donors')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('request_bloods');
    }
};
