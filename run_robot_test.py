import robot

files = ['tests/03_get_the_process_instance_result.robot']
options = {
    "variable": ["HELLO:world", "FOO:{'bar1': 1, 'bar2': 2}"],
}

rc = robot.run(*files, **options)
print(rc)
