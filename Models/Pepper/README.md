# Detect Pepper  Diseases
- Detecting pepper diseases using a Convolutional Neural Network (CNN) model has emerged as a valuable technique in the field of plant pathology.
  One specific disease that can be effectively identified through this approach is known as Pepper Bacterial Spot.



- Pepper Bacterial Spot is a common bacterial disease that affects pepper plants, causing significant damage to the leaves,
  stems, and fruits. By employing a CNN model, the process of detecting and classifying this disease can be automated, offering farmers and researchers
  a powerful tool for early detection and precise management.



- The CNN model is trained using a diverse dataset of pepper plant images, encompassing both healthy samples and those infected with Bacterial Spot.
  During the training phase, the model learns to extract relevant features and patterns from the images, enabling it to discern between healthy pepper plants
  and those afflicted by the disease. These features can include characteristic symptoms like dark, necrotic lesions on the leaves, leaf curling, and discoloration.


 
- When confronted with a new image of a pepper plant, the trained CNN model can accurately determine whether the plant is healthy or infected with Bacterial Spot.
  This information allows farmers to promptly implement appropriate measures, such as targeted treatment or removal of infected plants,
  to prevent further spread of the disease and minimize crop losses.


- Utilizing a CNN model for detecting Pepper Bacterial Spot not only enhances the accuracy and efficiency of disease identification but also
  contributes to the overall management and control of pepper diseases. By offering an automated and reliable method for disease detection,
  this technology assists farmers in making informed decisions, optimizing their agricultural practices, and ultimately ensuring the health and
  productivity of their pepper crops.

 
# How to run 
 - First Load image
   ``` img_path = "PathImage"
       img = image.load_img(img_path, target_size=(224, 224))
    ```
 - Second Preprocess the image
   ``` img_array = image.img_to_array(img)
       img_array = img_array / 255.0  # Normalize the image pixel values
       input_img = np.expand_dims(img_array, axis=0)
   ```
 - Third Perform prediction on the image
   ```predictions = model.predict(input_img)
     class_names = list(train_generator.class_indices.keys())
   ```
 - Fourth  Get the index and confidence of the maximum confidence prediction
   ```max_index = np.argmax(predictions[0])
      max_confidence = predictions[0][max_index]
      max_class_name = class_names[max_index]
   ```
 - Fifth Plot the image & Print the class and confidence below the image
   ```fig, ax = plt.subplots()
      ax.imshow(img)
      ax.axis('off')
      ax.text(0, 1.05, f"Class: {max_class_name}", transform=ax.transAxes, fontsize=12)
      ax.text(0, 1.1, f"Confidence: {max_confidence:.2f}", transform=ax.transAxes, fontsize=12)
      plt.show()
    ```

   
 - Finally, output is :


   ![Alt Text](Images/output.png)


# Dependencies
 - To install dependencies for your project, you can utilize the command specified by your project's build system or package manager. This command is designed to handle the   
   installation process without requiring any additional effort or input from you. By running this command, the necessary dependencies will be automatically fetched and installed, 
   ensuring that your project has access to all the required libraries and packages. The command typically analyzes the dependencies specified in a configuration file.

   ```
    pip install requirments.txt
   ```
