import os
firefoxProfilePath = os.environ['FIREFOXPROFILEPATH']
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions
options = webdriver.FirefoxOptions()
options.add_argument("--headless")
options.add_argument("--profile")
options.add_argument(firefoxProfilePath)
service = webdriver.FirefoxService(executable_path="/usr/bin/geckodriver")
driver = webdriver.Firefox(service=service, options=options)
driver.implicitly_wait(5)
