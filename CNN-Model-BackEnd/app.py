import os
from flask import Flask, request, render_template

from prediction import predict

app = Flask(__name__)
app.template_folder = '.'
uploads_directory = os.path.join('static', '.')
app.config['UPLOAD_FOLDER'] = uploads_directory

@app.route('/')
def home():
    return render_template('./ui/index.html')

@app.route('/api/predictions', methods=['POST'])
def get_prediction():
    image = request.files['image']
    image_path = os.path.join(os.getcwd(), "static", image.filename)

    image.save(image_path)
    prediction = predict(image_path)
    return render_template('./ui/show_prediction.html', prediction=prediction, image_name=image.filename)#هنا الريتررررررننننننننننننننننن
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
