import boto3
import datetime
import os

AMI_PREFIX = os.getenv("prefix")
REGION = os.getenv("region")

ec2 = boto3.client("ec2", REGION)


def delete_image(image_id):
    snap_desc = f"*{image_id}"
    snapshots = ec2.describe_snapshots(
        Filters=[{'Name': "description", "Values": [snap_desc,]},], MaxResults=10000)["Snapshots"]
    print(f"Deregistering image {image_id}")
    ami_response = ec2.deregister_image(DryRun=False, ImageId=image_id)
    print(ami_response)
    for snapshot in snapshots:
        if snapshot['Description'].find(image_id) > 0:
            snapResonse = ec2.delete_snapshot(
                SnapshotId=snapshot['SnapshotId'])
            print("Deleting snapshot " + snapshot['SnapshotId'])


AMI_NAME = "Test-Drive-*"
COUNT = 0
try:
    images = ec2.describe_images(
        Filters=[{'Name': 'name', 'Values': [AMI_NAME,]},], DryRun=False)['Images']
    sorted_images = sorted(
        images, key=lambda image: image["CreationDate"])
    for image in sorted_images:
        if len(sorted_images) <= 2:
            break
        COUNT = COUNT+1
        delete_image(image["ImageId"])
except Exception as exc:
    print(exc)
