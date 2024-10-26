<!-- admin/donor/create.blade.php -->
<div class="m-section">
    <div class="m-section__content">
        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('fullName', 'Full Name:') !!}
                {!! Form::text('fullName', null, ['class' => 'form-control']) !!}
                @error('fullName')
                    <div id="fullName-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-md-6">
                <label for="dob">Date of Birth:</label>
                <input id="dob" type="date" class="form-control @error('dob') is-invalid @enderror" name="dob" value="{{ old('dob') }}" required autocomplete="dob">
                @error('dob')
                <div id="dob-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
        </div>
        
        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('gender', 'Select Gender:') !!}
                {!! Form::select('gender', ['Male' => 'Male', 'Female' => 'Female'], null, ['class' => 'form-control']) !!}
                @error('gender')
                <div id="gender-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>


            <div class="col-lg-6">
                {!! Form::label('bloodGroup', 'Select Blood Group') !!}
                {!! Form::select('bloodGroup',['A+' => 'A+', 'B+' => 'B+','AB+' => 'AB+', 'O+' => 'O+','A-' => 'A-', 'B-' => 'B-','AB-' => 'AB-', 'O-' => 'O-'], null, ['class' => 'form-control']) !!}
                @error('bloodGroup')
                    <div id="bloodGroup-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
        </div>

        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('province', 'Province:') !!}
                {!! Form::select('province', $provinces, null, ['class' => 'form-control', 'id' => 'province']) !!}
                @error('province')
                    <div id="province-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-lg-6">
                {!! Form::label('district', 'District:') !!}
                {!! Form::select('district', [], null, ['class' => 'form-control', 'id' => 'district']) !!}
                @error('district')
                    <div id="district-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
        </div>

        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('localLevel', 'Local Level:') !!}
                {!! Form::select('localLevel', [], null, ['class' => 'form-control', 'id' => 'localLevel']) !!}
                @error('localLevel')
                    <div id="localLevel-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-lg-6">
                {!! Form::label('wardNo', 'Ward Number:') !!}
                {!! Form::text('wardNo', null, ['class' => 'form-control']) !!}
                @error('wardNo')
                    <div id="wardNo-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
        </div>

        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('phone', 'Contact Number:') !!}
                {!! Form::text('phone', null, ['class' => 'form-control']) !!}
                @error('phone')
                    <div id="phone-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>

            <div class="col-lg-6">
                {!! Form::label('email', 'Email:') !!}
                {!! Form::text('email', null, ['class' => 'form-control']) !!}
                @error('email')
                    <div id="email-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
        </div>
    </div>
    <div class="kt-portlet__foot">
        <div class="kt-form__actions">
            <div class="row">
                <div class="col-lg-6">
                    <button type="submit" class="btn btn-primary">{{ $formAction }}</button>
                    <a href="{{ route('admin-donor-create') }}" type="reset" class="btn btn-secondary">Cancel</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $('#province').change(function() {
            var provinceId = $(this).val();
            if (provinceId !== '') {
                $.ajax({
                    url: '{{ route("get-districts") }}',
                    type: 'GET',
                    data: { province_id: provinceId },
                    success: function(response) {
                        $('#district').empty();
                        $('#district').append('<option value="">Select District</option>');
                        $.each(response, function(key, value) {
                            $('#district').append('<option value="' + value + '">' + value + '</option>');
                        });
                    }
                });
            } else {
                $('#district').empty();
                $('#localLevel').empty();
            }
        });

        $('#district').change(function() {
            var districtName = $(this).val();
            if (districtName !== '') {
                $.ajax({
                    url: '{{ route("get-local-levels") }}',
                    type: 'GET',
                    data: { district_name: districtName },
                    success: function(response) {
                        $('#localLevel').empty();
                        $('#localLevel').append('<option value="">Select Local Level</option>');
                        $.each(response, function(key, value) {
                            $('#localLevel').append('<option value="' + value + '">' + value + '</option>');
                        });
                    }
                });
            } else {
                $('#localLevel').empty();
            }
        });
    });
</script>
