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
        Schema::create('event_statuses', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('evId');
            $table->unsignedBigInteger('doId');
            $table->boolean('like')->default(false);
            $table->boolean('attend')->default(false);
            $table->foreign('evId')->references('eventId')->on('load_events');
            $table->foreign('doId')->references('donorId')->on('reg_donors')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('event_statuses');
    }
};
