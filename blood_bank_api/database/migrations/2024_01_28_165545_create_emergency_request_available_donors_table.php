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
        Schema::create('emergency_request_available_donors', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('erAvailableId');
            $table->unsignedBigInteger('donorAvailableId');
            $table->foreign('erAvailableId')->references('emergencyRequestId')->on('emergency_request_bloods')->onDelete('cascade');
            $table->foreign('donorAvailableId')->references('donorId')->on('reg_donors')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('emergency_request_available_donors');
    }
};
