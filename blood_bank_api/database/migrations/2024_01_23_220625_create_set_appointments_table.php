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
        Schema::create('set_appointments', function (Blueprint $table) {
            $table->bigIncrements('appointmentId'); 
            $table->string('about');           
            $table->date('setDate');
            $table->time('setTime');
            $table->string('remarks');          
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
        Schema::dropIfExists('set_appointments');
    }
};
