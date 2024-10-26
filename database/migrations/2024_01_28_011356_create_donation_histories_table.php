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
        Schema::create('donation_histories', function (Blueprint $table) {
            $table->bigIncrements('dhId'); 
            $table->date('donatedDate');
            $table->string('donatedTo');
            $table->unsignedTinyInteger('bloodPint')->nullable()->default(0); // Define bloodPint with maximum 2    
            $table->string('contact');                            
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
        Schema::dropIfExists('donation_histories');
    }
};
