<?php

namespace App\Exports\Admin;

use App\Models\AmbulanceInfo;
use App\Models\RegDonor;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;

class AmbulanceInfoExport implements FromCollection, WithHeadings
{
    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        // Perform a join between AmbulanceInfo and RegDonor tables
        $data = AmbulanceInfo::leftJoin('reg_donors', 'ambulance_infos.doId', '=', 'reg_donors.donorId')
            ->select(
                'ambulance_infos.name',
                'ambulance_infos.contactNo',
                'ambulance_infos.province',
                'ambulance_infos.district',
                'ambulance_infos.localLevel',
                'ambulance_infos.wardNo',
                'reg_donors.fullname'
            )
            ->get();

        return $data;
    }

    /**
     * @return array
     */
    public function headings(): array
    {
        return [
            'Sewa Name',
            'Contact No',
            'Province',
            'District',
            'Local Level',
            'Ward No',
            'Added By'
        ];
    }
}
