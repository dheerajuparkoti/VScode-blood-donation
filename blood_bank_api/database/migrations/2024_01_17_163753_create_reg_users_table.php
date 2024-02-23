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
        Schema::create('reg_users', function (Blueprint $table) {
            $table->id();               
            $table->string('email')->unique();
            $table->string('username')->unique();
            $table->string('password')->min(8);
            $table->string('accountType')->default('Member');
            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reg_users');
    }
};
