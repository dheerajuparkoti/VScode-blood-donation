<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LoadEvents extends Model
{
    use HasFactory;
    protected $table = 'load_events';
    protected $primaryKey = 'eventId';

    public function statuses()
    {
        return $this->hasMany(EventStatus::class, 'evId');
    }

}
