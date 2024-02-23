<?php

namespace App\Imports\Admin;

use App\Models\AmbulanceInfo;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class AmbulanceInfoImport implements ToModel,WithHeadingRow
{
    /**
    * @param array $row
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        return new AmbulanceInfo([
            'name' => $row['ambulancename'],
            'contactNo' => $row['contact'],
            'province' => $row['provinceno'],
            'district' => $row['district'],
            'localLevel' => $row['locallevel'],
            'wardNo' => $row['wardno'],
            'doId' => $row['id'],   
        ]);
    }
}
