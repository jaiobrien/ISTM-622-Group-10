-- Create the TemperatureReadings table to store the data

create table TemperatureReadings (
    time timestamptz not null,
    device_id text not null,
    temperature double precision null,
    humidity double precision null
);

/* Create a hyptertable from the TemperatureReadings table that partitions the
data based off of time */

select create_hypertable('TemperatureReadings', 'time');

-- Select all the temperature readings from the previous day for sensor_001

select time, temperature
from TemperatureReadings
where device_id = 'sensor_001'
  and time > now() - interval '1 day'
order by time;

-- Select all data from the TemperatureReadings table for the past hour

select * 
from TemperatureReadings
where time > now() - interval '1 hour'
order by time desc;

-- Use time_bucket to aggregate all data in the past hour

select 
  device_id,
  time_bucket('1 hour', time) as bucket,
  avg(temperature) as avg_temp,
  avg(humidity) as avg_humidity
from TemperatureReadings
group by device_id, bucket
order by bucket, device_id;
