from ultralytics import YOLO

# Load a model
# model = YOLO('yolov8n.pt')  # load an official model
model = YOLO('best.pt')  # load a custom model

# Predict with the model
results = model(source=0, show=True, conf=0.4, save=False)
print(results)