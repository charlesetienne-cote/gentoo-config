driver.switch_to.window(driver.window_handles[0])
driver.switch_to.new_window('tab')
driver.get("about:debugging#addons")
ublockUUID = driver.find_element(By.XPATH, "//dd[text()='cors-everywhere@spenibus']/parent::*/parent::*/div[2]/dd").text
ublockURL = "moz-extension://"+ublockUUID+"/options.html"
driver.get(ublockURL)
WebDriverWait(driver, 10).until(expected_conditions.element_to_be_clickable((By.ID, "enabledAtStartup")))
driver.find_element(By.ID, "enabledAtStartup").click()
WebDriverWait(driver, 10).until(expected_conditions.element_to_be_clickable((By.XPATH, "//button")))
driver.find_element(By.XPATH, "//button").click()
WebDriverWait(driver, 10).until(expected_conditions.element_to_be_clickable((By.XPATH, "//button")))
driver.close()
