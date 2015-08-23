//
//  ViewController.m
//  OpenCV
//
//  Created by 丁琪 on 15/8/23.
//  Copyright (c) 2015年 丁琪. All rights reserved.
//

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>

@interface ViewController ()
{
    cv::CascadeClassifier faceDetector;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加xml文件
    NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource:@"haarcascade_frontalface_alt"
                             ofType:@"xml"];
    faceDetector.load([cascadePath UTF8String]);

   
    //上传图片
    UIImage *image = [UIImage imageNamed:@"lena1.png"];
    cv::Mat faceImage;
    UIImageToMat(image, faceImage);
    
    // 转为灰度
    cv::Mat gray;
    cvtColor(faceImage, gray, CV_BGR2GRAY);
    
    // 检测人脸并储存
    std::vector<cv::Rect>faces;
    faceDetector.detectMultiScale(gray, faces,1.1,2,0|CV_HAAR_SCALE_IMAGE,cv::Size(30,30));
    
     // 在每个人脸上画一个红色四方形
    for(unsigned int i= 0;i < faces.size();i++)
    {
        const cv::Rect& face = faces[i];
        cv::Point tl(face.x,face.y);
        cv::Point br = tl + cv::Point(face.width,face.height);
        
        // 四方形的画法
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(faceImage, tl, br, magenta, 4, 8, 0);
    }
    
    self.imgView.image = MatToUIImage(faceImage);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
