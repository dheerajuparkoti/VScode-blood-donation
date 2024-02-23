@extends('admin.layouts.master')
@section('content') 
<div class="m-content">
    <div class="m-portlet">
        <div class="m-portlet__head">
            <div class="m-portlet__head-wrapper">
                <div class="m-portlet__head-caption">
                    <div class="m-portlet__head-title">
                    <head>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
                    <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" relation="stylesheet"> 
                         
                    </head>
                        <h3 class="m-portlet__head-text">
                            DONORS DATA
                        </h3>
                    </div>
                </div>
                <div class="m-portlet__head-tools">
                <a href="{{ route('admin-donor-create') }}" class="btn btn-success m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-plus"></i>
                            <span>Create</span>
                        </span>                         
                    </a>
                    <!-- import button-->
                    <a href="{{ route('admin-donor-import') }}" class="btn btn-primary m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-upload"></i>
                            <span>Import</span>
                        </span>
                    </a>
                    <a href="{{ route('admin-donor-export') }}" class="btn btn-primary m-btn m-btn--icon m-btn--wide m-btn--md m--margin-right-10">
                        <span>
                            <i class="fa fa-upload"></i>
                            <span>Export</span>
                        </span>
                    </a>
                   
                </div>
            </div>
        </div>
        <div class="m-portlet__body">
            <div class="m-section">
                <div class="m-section__content">
                    
                <!-- retrieving message from controller if deleted successfully-->  
                @if(session()->has('message'))
                <div class="alert alert-success">
                    {{ session()->get('message') }}
                </div>
                @endif

                @if(isset($message))
                <div class="alert alert-info">
                    {{ $message }}
                </div>
                @endif

                <!-- Search Bar -->
                <form action="{{ route('admin-donor-show') }}" method="GET">
                    <div class="form-row align-items-center mb-3">    
                        <div class="col-auto">
                            <label class="sr-only" for="name">bloodGroup</label>
                            <input type="text" class="form-control" id="bloodGroup" name="bloodGroup" placeholder="Search by blood group">
                        </div>                                                            
                        <div class="col-auto">
                            <input type="text" class="form-control" name="address" placeholder="Search by Address">
                        </div> 
                        <div class="col-auto">
                            <label class="sr-only" for="name">phone</label>
                            <input type="text" class="form-control" id="phone" name="phone" placeholder="Search by phone">
                        </div> 
                        <div class="col-auto">
                            <label class="sr-only" for="name">email</label>
                            <input type="text" class="form-control" id="email" name="email" placeholder="Search by email">
                        <div class="col-auto">
                        <!-- Add some space between rows -->
                        <div style="margin-top: 10px;"></div>
                        </div> 

                        </div> 
                         <div class="col-auto">
                            <label class="sr-only" for="name">canDonate</label>
                            <input type="text" class="form-control" id="canDonate" name="canDonate" placeholder="Search by CanDonate ?">
                        </div>  
                        <div class="col-auto">
                            <label class="sr-only" for="name">gender</label>
                            <input type="text" class="form-control" id="gender" name="gender" placeholder="Search by gender">
                        </div>    
                        <div class="col-auto">
                            <label class="sr-only" for="name">username</label>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Search by username">
                        </div>          

                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">Search Now</button>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="ambulanceTable">
                        <thead>
                            <tr class="table-primary">                               
                                <th>Donor Id</th>
                                <th>Name</th>
                                <th>DOB</th>                                
                                <th>Gender</th>                                
                                <th>Blood Group</th>
                                <th>Address</th>
                                <th>Phone</th>
                                <th>Email</th>
                                <th>Can Donate ?</th>
                                <th>Username</th>   
                                <th>Action</th>                             
                            </tr>
                        </thead>
                    
                    
                            <tbody>                           
                            @foreach ($donors as $donor)
                                <tr class="dd">
                                    <td>{{ $donor->donorId }}</td>
                                    <td>{{ $donor->fullName}}</td>
                                    <td>{{ $donor->dob}}</td>   
                                    <td>{{ $donor->gender}}</td>                                   
                                    <td>{{ $donor->bloodGroup}}</td>     
                                    <td>{{ $donor->localLevel }},- {{ $donor->wardNo }}, {{ $donor->district }}, Pro. {{ $donor->province }}</td>                                
                                    <td>{{ $donor->phone}}</td>                                   
                                    <td>{{ $donor->email}}</td>                                   
                                    <td>{{ $donor->canDonate}}</td>                                                                   
                                    <td>{{ $donor->user->username}}</td>  
                                    <td style="text-align: center; vertical-align: middle;">
                                        <form method="POST" action="{{ route('admin-donor-delete', ['id' => $donor->donorId]) }}">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this donor data? Once you delete, you will not be able to revert the changes!')" style="padding: 5px 10px;">
                                                <div class="d-flex align-items-center justify-content-center">Delete</div>
                                            </button>
                                        </form>
                                    </td>                    
                                </tr>
                                @endforeach
                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="12">
                                        <!-- Pagination links -->
                                        <div class="pagination justify-content-center">
                                            {{ $donors->onEachSide(2)->links() }}
                                        </div>
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>      
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
