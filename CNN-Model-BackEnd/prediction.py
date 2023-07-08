from tensorflow.keras.preprocessing import image
import numpy as np
from PIL import Image
from tensorflow.keras.models import load_model

class_names_map = [ ['Pepper_Bacterial_spot', 'Pepper_healthy','nonValid'],['Strawberry___Leaf_scorch', 'Strawberry___healthy', 'nonValid']]

model_path = {"pepper_model": "C:/Users/Nada/Downloads/TEST/models/PepperModel.h5",
              "strawberry_model": "C:/Users/Nada/Downloads/TEST/models/StrawbeeryModel.h5"}


def predict( img_path: str):
    prediction=''
    temp_prediction=0
    i=-1
    for model_name in model_path:
        i=i+1
        ModelPath = model_path[model_name]
        model = load_model(ModelPath)
        img = image.load_img(img_path, target_size=(224,224))
        img_array = image.img_to_array(img)
        img_array = img_array / 255.0  # Normalize the image pixel values
        input_img = np.expand_dims(img_array, axis=0)
        predictions = model.predict(input_img)
        max_confidence_index = np.argmax(predictions)
        max_confidence_value=predictions[0][max_confidence_index]
        if max_confidence_index != len(predictions[0])-1:
            if max_confidence_value>temp_prediction:
                prediction=class_names_map[i][max_confidence_index]
                temp_prediction=max_confidence_value
    if prediction=='':
        return "we can't recognize input"

    return prediction
