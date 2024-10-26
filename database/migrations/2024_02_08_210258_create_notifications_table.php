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
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('rId')->nullable();
            $table->unsignedBigInteger('erId')->nullable();
            $table->unsignedBigInteger('evId')->nullable();
            $table->boolean('isRead')->default(false);
            $table->unsignedBigInteger('doId')->nullable();
            $table->timestamps();

            // Foreign key constraints
            $table->foreign('rId')->references('requestId')->on('request_bloods')->onDelete('cascade');
            $table->foreign('erId')->references('emergencyRequestId')->on('emergency_request_bloods')->onDelete('cascade');
            $table->foreign('evId')->references('eventId')->on('load_events')->onDelete('cascade');
            $table->foreign('doId')->references('donorId')->on('reg_donors')->onDelete('cascade');
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};
