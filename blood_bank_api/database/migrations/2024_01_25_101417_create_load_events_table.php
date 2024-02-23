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
        Schema::create('load_events', function (Blueprint $table) {
           
            $table->bigIncrements('eventId'); 
            $table->string('eventName');
            $table->string('venue');
            $table->string('chiefGuest');
            $table->text('eventDetail');
            $table->string('organizedBy');
            $table->string('contactNo');
            $table->integer('province')->max(1);;
            $table->string('district');
            $table->string('localLevel');
            $table->integer('wardNo')->max(2); 
            $table->date('eventDate');
            $table->time('eventTime');                  
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
        Schema::dropIfExists('load_events');
    }
};
