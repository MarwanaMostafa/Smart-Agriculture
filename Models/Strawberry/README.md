# Detect Strawberry Diseases
-Detecting strawberry diseases using a Convolutional Neural Network (CNN) model has proven to be an effective and promising approach in the field of plant 
 pathology. One of the diseases that can be accurately identified through this method is known as Strawberry Leaf Scorch. 

-Strawberry Leaf Scorch is a common fungal disease that affects strawberry plants, causing severe damage to their foliage and reducing fruit yield. By 
 utilizing a CNN model, the identification and classification of this disease can be automated, providing farmers and researchers with a valuable tool for 
 early detection and effective management.

-The CNN model is trained on a diverse dataset of strawberry leaf images, encompassing both healthy and infected samples. During the training process, the 
 model learns to extract relevant features and patterns from the images, enabling it to differentiate between healthy strawberry leaves and those affected by 
 Leaf Scorch. These features can include discoloration, necrotic lesions, or characteristic patterns specific to the disease.
 
-When presented with a new image of a strawberry leaf, the trained CNN model can accurately predict whether the leaf is healthy or infected with Leaf Scorch. 
 This information allows farmers to take appropriate measures, such as targeted treatment or removal of infected plants, to prevent the spread of the disease 
 and minimize crop losses.

-The use of a CNN model for detecting Strawberry Leaf Scorch not only improves the accuracy and efficiency of disease identification but also aids in the 
 overall management and control of strawberry diseases. By providing an automated and reliable method for disease detection, this technology assists farmers 
 in making informed decisions, optimizing their farming practices, and ultimately ensuring the health and productivity of their strawberry crops.
 
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
