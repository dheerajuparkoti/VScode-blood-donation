<?php

namespace App\Imports\Admin;

use App\Models\BloodBankInfo;
use Maatwebsite\Excel\Concerns\ToModel;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class BloodBankInfoImport implements ToModel,WithHeadingRow
{
    /**
    * @param array $row
    *
    * @return \Illuminate\Database\Eloquent\Model|null
    */
    public function model(array $row)
    {
        return new BloodBankInfo([
            'name' => $row['bloodbankname'],
            'contactNo' => $row['contact'],
            'province' => $row['provinceno'],
            'district' => $row['district'],
            'localLevel' => $row['locallevel'],
            'wardNo' => $row['wardno'],
            'doId' => $row['id'],          
        ]);
    }
}
