<!-- admin/bloodbank/create.blade.php -->
<div class="m-section">
    <div class="m-section__content">
        <div class="form-group row">
            <div class="col-lg-6">
                {!! Form::label('name', 'Name:') !!}
                {!! Form::text('name', null, ['class' => 'form-control']) !!}
                @error('name')
                    <div id="name-id-error" class="error invalid-feedback">{{ $message }}</div>
                @enderror
            </div>
            <div class="col-lg-6">
                {!! Form::label('contactNo', 'Contact Number:') !!}
                {!! Form::text('contactNo', null, ['class' => 'form-control']) !!}
                @error('contactNo')
                    <div id="contactNo-id-error" class="error invalid-feedback">{{ $message }}</div>
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
    </div>
    <div class="kt-portlet__foot">
        <div class="kt-form__actions">
            <div class="row">
                <div class="col-lg-6">
                    <button type="submit" class="btn btn-primary">{{ $formAction }}</button>
                    <a href="{{ route('admin-bloodbank-create') }}" type="reset" class="btn btn-secondary">Cancel</a>
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
