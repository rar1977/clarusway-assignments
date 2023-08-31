# Streamlit Documentation: https://docs.streamlit.io/
import streamlit as st
import pandas as pd
import numpy as np
from PIL import Image  # to deal with images (PIL: Python imaging library)

# Title/Text
st.title("This is a the price prediction app!")

## Streamlit for Price Prediction App

# To load machine learning model
import pickle
filename = "my_final_model"
model=pickle.load(open(filename, "rb"))

# To take feature inputs
#make_model = st.sidebar.number_input("Model:",min_value=5, max_value=300)
make_model = st.sidebar.selectbox("Model:", ["Audi A1", "Audi A3", "Opel Astra", "Opel Insignia", "Opel Corsa", "Renault Clio", "Renault Espace" ])
hp_kW = st.sidebar.number_input("Horsepower:",min_value=40, max_value=300)
km = st.sidebar.number_input("Kilometer:",min_value=0, max_value=350000)
age = st.sidebar.number_input("Age:",min_value=0, max_value=3)
Comfort_Convenience = st.sidebar.number_input("Comfort Features:",min_value=0, max_value=20)
Displacement_cc = st.sidebar.number_input("CC:",min_value=500, max_value=3500)


# Create a dataframe using feature inputs
my_dict = {"make_model":make_model,
           "hp_kW":hp_kW,
           "km":km,
            "age":age,
            "Comfort_Convenience":Comfort_Convenience,
            "Displacement_cc":Displacement_cc,
           }
df = pd.DataFrame.from_dict([my_dict])
st.table(df)

# Prediction with user inputs
predict = st.button("Predict")
result = model.predict(df)
if predict :
    st.success(result[0])