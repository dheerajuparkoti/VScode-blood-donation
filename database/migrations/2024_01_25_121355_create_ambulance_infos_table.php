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
        Schema::create('ambulance_infos', function (Blueprint $table) {
            $table->bigIncrements('ambulanceInfoId'); 
            $table->string('name');
            $table->string('contactNo')->max(10);
            $table->integer('province')->max(1);
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
        Schema::dropIfExists('ambulance_infos');
    }
};
