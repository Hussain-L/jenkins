#!/bin/bash
sudo apt update -y
amazon-linux-extras install nginx1.12
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo sh -c "echo '<h1> Hello World from Hussain  $(hostname) </h1>'  > /usr/share/nginx/html/index.html"
sudo sh -c "echo '{
    \"agent\": {
            \"metrics_collection_interval\": 60,
            \"run_as_user\": \"root\"
    },
    \"metrics\": {
            \"aggregation_dimensions\": [
                    [
                            \"InstanceId\"
                    ]
            ],
            \"append_dimensions\": {
                    \"AutoScalingGroupName\": \"\${aws:AutoScalingGroupName}\",
                    \"ImageId\": \"\${aws:ImageId}\",
                    \"InstanceId\": \"\${aws:InstanceId}\",
                    \"InstanceType\": \"\${aws:InstanceType}\"
            },
            \"metrics_collected\": {
                    \"disk\": {
                            \"measurement\": [
                                    \"used_percent\"
                            ],
                            \"metrics_collection_interval\": 60,
                            \"resources\": [
                                    \"*\"
                            ]
                    },
                    \"mem\": {
                            \"measurement\": [
                                    \"mem_used_percent\"
                            ],
                            \"metrics_collection_interval\": 60
                    }
            }
    }
}' > /home/ec2-user/config.json"
sudo yum install amazon-cloudwatch-agent -y
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/home/ec2-user/config.json