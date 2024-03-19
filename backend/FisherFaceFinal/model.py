
import os
import numpy as np
import random

from collections import Counter, defaultdict
from glob import glob
from matplotlib import pyplot as plt

import dlib
import cv2
import os


class Model:
    def train(self):
        current_dir = os.getcwd() + "\\FisherFaceFinal"
        file_names = []
        self.face_classes = defaultdict(list)

        self.train_class = []
        test_clas = []

        self.train_matrix = []
        test_matri = []

        index = 0

        # training
        for student_folder in os.listdir(os.path.join(current_dir, 'Dataset_250')):
            student_folder_path = os.path.join(current_dir, 'Dataset_250', student_folder)

            file_name_pattern = os.path.join(student_folder_path, '*.jpg')
            file_name_list = glob(file_name_pattern)
            file_names.extend(file_name_list)
        

        for i, image_path in enumerate(file_names):

            person_name = os.path.basename(os.path.dirname(image_path))

            current_face = plt.imread(image_path)
            image_shape = current_face.shape

            current_face = current_face.flatten()

            self.face_classes[person_name].append(index)
            self.train_matrix.append(current_face)
            self.train_class.append(person_name)
            index += 1
        

        # pca
        self.MEAN = np.mean(self.train_matrix, axis=0)
        self.train_matrix = self.train_matrix - self.MEAN

        # Compute the covariance
        covariance = np.cov(self.train_matrix)
        # Compute the eigen pairs
        _, selected_eigen = np.linalg.eigh(covariance)

        # Project to eigen space
        self.eigen_space = np.dot(selected_eigen.T, self.train_matrix) 
        # Get the new dimension for train_matrix
        self.train_matrix = np.dot(self.train_matrix, self.eigen_space.T)
    

        SW = np.zeros((len(self.train_matrix), len(self.train_matrix)))

        for class_name, index in self.face_classes.items():
            face_mean = self.calculate_class_mean(class_name).reshape(-1, 1)
            for idx in index:
                image = self.train_matrix[idx, :].reshape(-1, 1)
                SW += np.dot(image - face_mean, (image - face_mean).T)
            
            
        print(f"Scatter within matrix: \n {SW}")

        gloabl_mean = np.mean(self.train_matrix, axis=0)
        SB = np.zeros((len(self.train_matrix), len(self.train_matrix)))

        for class_name, index in self.face_classes.items():
            face_mean = self.calculate_class_mean(class_name).reshape(-1, 1)
            SB += (len(index) * np.dot(face_mean - gloabl_mean, (face_mean - gloabl_mean).T))
            
        print(f"Scatter Between Matrix: \n {SB}")

        unrefined_eigen = np.dot(np.linalg.inv(SW.T), SB.T)
        svd = np.linalg.svd(unrefined_eigen)

        eig_val, eig_vec = svd[1], svd[0]
        eig_val = np.abs(eig_val)
        eigen_pairs = sorted([(eig_val[i], eig_vec[:, i]) for i in range(len(eig_val))], key=lambda x: x[0], reverse=True)

        for i in eigen_pairs:
            print(i[0])

        eigv_sum = sum(eig_val)
        cumsum = eig_val.cumsum()

        # for i, j in enumerate(cumsum):
        #     print('Eigen value {0:}: {1: .2%}'.format(i + 1, (j / eigv_sum).real))

        k = 10
        self.chosen_eigen = np.array([i[1] for i in eigen_pairs])

        self.projection_space = np.dot(self.train_matrix, self.chosen_eigen.T)

        # self.projection_space.shape

        test_dir = os.getcwd() + "\\FisherFaceFinal"
        test_names = []
        test_classes = defaultdict(list)

        test_class = []
        test_matrix = []
        index = 0

        for student_folder in os.listdir(os.path.join(test_dir, 'testfinal')):
            student_folder_path = os.path.join(test_dir, 'testfinal', student_folder)

            test_name_pattern = os.path.join(student_folder_path, '*.jpg')
            test_name_list = glob(test_name_pattern)
            test_names.extend(test_name_list)

        for i, image_path in enumerate(test_names):

            person_name = os.path.basename(os.path.dirname(image_path))

            current_face = plt.imread(image_path)
            image_shape = current_face.shape

            current_face = current_face.flatten()

            test_classes[person_name].append(index)
            test_matrix.append(current_face)
            test_class.append(person_name)
            index += 1


    def calculate_class_mean(self, class_name,):
        mean_val = []
        for i in self.face_classes[class_name]:
            mean_val.append(self.train_matrix[i, :])
        
        return np.mean(np.array(mean_val), axis=0)
 
    def detect_and_save_faces(self, input_image_path, output_folder, n=250):
        detector = dlib.get_frontal_face_detector()

        image = cv2.imread(input_image_path)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        faces = detector(gray)

        os.makedirs(output_folder, exist_ok=True)    
        for i, face in enumerate(faces):
            x, y, w, h = face.left(), face.top(), face.width(), face.height()
            face_image = image[y:y+h, x:x+w]

                                    
            resized_face = cv2.resize(face_image, (n, n))
            grayscale_face = cv2.cvtColor(resized_face, cv2.COLOR_BGR2GRAY)

            output_filename = os.path.join(output_folder, f'{i}.jpg')
            cv2.imwrite(output_filename, grayscale_face)


    def find_diff(self, file_path, actual):
        test = plt.imread(file_path)
        test = test.flatten()
        
        # Assuming MEAN, eigen_space, chosen_eigen, projection_space, and train_class are defined somewhere
        
        test = test - self.MEAN
        test = np.dot(test, self.eigen_space.T)
        test = np.dot(test, self.chosen_eigen.T)
        
        diff = self.projection_space - test
        ed = list(np.linalg.norm(diff, axis=1))
        
        ad = [*ed]
        ad.sort()
        
        n = 10
        s = ad[:n]
        
        sl = [self.train_class[ed.index(neighbor)] for neighbor in s]

        lc = Counter(sl)
        pn = max(lc, key=lc.get)
    
        an = actual 

        print("Prediction:", pn)
        return pn


# mymodel = Model()
# mymodel.train()
# input_im = 'grp.jpg'
# output_detected_faces_folder = f'./test{input_im}'


# mymodel.detect_and_save_faces(input_im, output_detected_faces_folder, 250)

# directory_path = os.getcwd() + "/testgrp.jpg"

# for filename in os.listdir(directory_path):
#     if filename.endswith(".jpg"):
#         file_path = os.path.join(directory_path, filename)
#         actual = "Yanet"  # You might need to determine the actual label based on the file or directory name
#         mymodel.find_diff(file_path, actual)

