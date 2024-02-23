<?php
namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\AmbulanceInfo;
use Yajra\DataTables\DataTables;
use Maatwebsite\Excel\Facades\Excel;
use App\Imports\Admin\AmbulanceInfoImport;
use App\Exports\Admin\AmbulanceInfoExport;
use App\Data\DistrictData;




class AmbulanceInfoController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {              
        $ambulanceInfo = AmbulanceInfo::orderBy('created_at', 'desc')->paginate(25); 
        return view('admin.ambulance.index',compact('ambulanceInfo'));
   
    }

    /**
     * Show the form for creating a new resource.
     */
    

     /*

    public function create(Request $request)
    {
    
    $formData = $this->renderForm($request);
   
   return view('admin.ambulance.create', $formData);
   return view('admin.ambulance.create');
    }
    */
    
    public function create(Request $request)
    {
        $provinces = DistrictData::getProvinces();
        return view('admin.ambulance.create', compact('provinces'));
    }

    

    /**
     * Show the form for importing a new resource.
     */
    public function import()
    {
        return view('admin.ambulance.import');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
{
    $storeData = $request->all();  
    // Set doId
    $storeData['doId'] = 2;
    
    // Create AmbulanceInfo instance with modified store data
    AmbulanceInfo::create($storeData);

    return redirect()->route('admin-ambulance-data')->with('message', 'Ambulance data creates successfully');
}

    /**
     * Show the form for creating a new resource.
     */
    public function storeImport(Request $request)
    {
        $file = $request->file('file');
        Excel::import(new AmbulanceInfoImport, $file);
        
        return redirect()->route('admin-ambulance-data')->with('success', 'All good!');
    }

    public function export() 
    {
               
        return Excel::download(new AmbulanceInfoExport, 'ambulanceinfo.xlsx');
      
    }
    /**
     * Display the specified resource.
     */
    public function show(Request $request)
    {
        $query = AmbulanceInfo::query();
        $searchText = '';
    
        // Check if requiredDate is provided in the request
        if ($request->has('name')) {
            $name = $request->input('name');
            $query->where('name', 'like', '%' . $name . '%');
            $searchText .= $name;
        }

        // Check if address is provided in the request
        if ($request->has('address')) {
            $address = $request->input('address');
            $query->where(function ($query) use ($address) {
                $query->where('localLevel', 'like', '%' . $address . '%')
                    ->orWhere('wardNo', 'like', '%' . $address . '%')
                    ->orWhere('district', 'like', '%' . $address . '%')
                    ->orWhere('province', 'like', '%' . $address . '%');
            });
            if ($searchText !== '') {
                $searchText .= ' ';
            }
            $searchText .= $address;
        }
    
        // Fetch request bloods based on the search criteria
        $ambulanceInfo = $query->orderBy('created_at', 'desc')->paginate(100);
    
        // Count the number of results
        $count = $ambulanceInfo->count();
    
        // Prepare the message
        $message = "Showing $count results for search: $searchText";
    
        return view('admin.ambulance.index', compact('ambulanceInfo', 'message'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
         // Find the record by requestId
         $ambulanceInfo = AmbulanceInfo::where('ambulanceInfoId', $id)->first();
         // check if requestId exists or not
         if (!$ambulanceInfo) {
             return redirect()->back()->with('message', 'Ambulance data not found or already deleted by the user priliviges with admin.');
         }
         else{
             $ambulanceInfo->delete();
             return redirect()->back()->with('message', 'Ambulance data deleted successfully');
 
         }
    }
    /*

    public function renderForm(Request $request)
{
    $provinces = DistrictData::getProvinces();
    $districts = DistrictData::getDistricts($request->input('province_id')); // Pass the selected province ID if needed
    $localLevels = DistrictData::getLocalLevels($request->input('district_id')); // Pass the selected district ID if needed

    // Return the data as an array
    return ['provinces' => $provinces, 'districts' => $districts, 'localLevels' => $localLevels];
}
*/


public function getDistricts(Request $request)
{
    $provinceId = $request->province_id;
    $districts = DistrictData::getDistricts($provinceId);
    return response()->json($districts);
}

public function getLocalLevels(Request $request)
{
    $districtName = $request->district_name;
    $localLevels = DistrictData::getLocalLevels($districtName);
    return response()->json($localLevels);
}
   
}
