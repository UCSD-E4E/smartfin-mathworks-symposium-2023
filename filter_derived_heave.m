function [acceleration, velocity, position] = filter_derived_heave(sensor_data, sampling_rate, target_frequency)
    function valid = validate_sensor_data(sensor_data)
        if ~istable(sensor_data)
            error("sensor_data is not a table.");
        end
    
        valid = any("Accelerometer" == string(sensor_data.Properties.VariableNames));
        valid = valid && any("Gyroscope" == string(sensor_data.Properties.VariableNames));
    
        if ~valid
            error("sensor_data needs Accelerometer and Gyroscope columns to use imufilter.  To use ahrsfilter, it needs Accelerometer, Gyroscope, Magnetometer.");
        end
    end

    function rotation = get_world_rotation(sensor_data, sampling_rate)
        use_ahrs = any("Magnetometer" == string(sensor_data.Properties.VariableNames));
        if use_ahrs
            fuse = ahrsfilter('SampleRate', sampling_rate, 'ReferenceFrame', 'ENU', 'OrientationFormat', 'Rotation matrix');
            rotation = fuse(sensor_data.Accelerometer, sensor_data.Gyroscope, sensor_data.Magnetometer);
        else
            fuse = imufilter('SampleRate', sampling_rate, 'ReferenceFrame', 'ENU', 'OrientationFormat', 'Rotation matrix');
            rotation = fuse(sensor_data.Accelerometer, sensor_data.Gyroscope);
        end
    end

    function world_acceleration = get_world_acceleration(accelerometer, world_rotation)
        world_acceleration = zeros(size(sensor_data.Accelerometer));
        for idx = 1:size(world_acceleration, 1)
            world_acceleration(idx, :) = world_rotation(:, :, idx)' * accelerometer(idx, :)';
        end
    end

    function [velocity, position] = get_velocity_position(world_acceleration_z, sampling_frequency)
        world_acceleration_z = world_acceleration_z + 9.80665;

        count = size(world_acceleration_z, 1);
        velocity = zeros(count, 1);
        position = zeros(count, 1);

        for idx = 1:count
            velocity(idx) = sum(world_acceleration_z(1:idx)) * (1 / sampling_frequency);
            position(idx) = sum(velocity(1:idx)) * (1 / sampling_frequency);
        end
    end

    validate_sensor_data(sensor_data);
    world_rotation = get_world_rotation(sensor_data, sampling_rate);
    acceleration = get_world_acceleration(sensor_data.Accelerometer, world_rotation);
    world_acceleration_z = downsample(acceleration(:, 3), int32(sampling_rate) / target_frequency);

    [velocity, position] = get_velocity_position(world_acceleration_z, target_frequency);
end