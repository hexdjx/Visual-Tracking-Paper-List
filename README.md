# Visual Tracking Paper List 
This repository records the visual tracking papers I have read, and I also make a brief summary for each paper.  

## 2022
* Unicorn: "Towards Grand Unification of Object Tracking" ECCV (Oral). [[Paper]](https://arxiv.org/abs/2207.07078)  
  VOT/VOS/MOT/MOTS多任务的统一，主要是解决VOT与MOT的统一问题，其他两个任务加个分割分支。两阶段训练网络模型：VOT/MOT与VOS/MOTS数据集。方法结构简单，论文易读，解决问题新颖实用。
* RTS: "Robust Visual Tracking by Segmentation" ECCV. [[Paper]](https://arxiv.org/abs/2203.11191)  
  PrDiMP与LWL的组合。分割式跟踪，采用PrDiMP的得分图作为LWL的先验信息获取更准确的分割Mask。
* ToMP: "Transforming Model Prediction for Tracking" CVPR. [[Paper]](https://openaccess.thecvf.com/content/CVPR2022/html/Mayer_Transforming_Model_Prediction_for_Tracking_CVPR_2022_paper.html)  
  基于SuperDiMP,提出Transformer架构的目标分类器，矩形框回归采用ltrb表达。   
* "MixFormer: End-to-End Tracking with Iterative Mixed Attention" CVPR (Oral). [[Paper]](https://openaccess.thecvf.com/content/CVPR2022/html/Cui_MixFormer_End-to-End_Tracking_With_Iterative_Mixed_Attention_CVPR_2022_paper.html)    
   参照目标检测的CVT, Siamese网络与Transformer架构，堆叠混合注意力模块将特征提取与聚合统一处理，外加一个corner预测头；设计一个得分预测模块选择高质量模板用于更新模板。
* "Global Tracking via Ensemble of Local Trackers" CVPR. [[Paper]](http://arxiv.org/abs/2203.16092)  
   针对长期目标跟踪的改进，网络使用了ResNet50+Transformer+DETR预测头。与re-detection 和 global tracking跟踪方式不同，采用10个局部跟踪器（参照Deformable DETR）的集成实现全局跟踪。另外，KeepTrack的LaSOT结果与原作者提供的不一致。  

## 2021
* KeepTrack: "Learning Target Candidate Association to Keep Track of What Not to Track" ICCV. [[Paper]](http://openaccess.thecvf.com/content/ICCV2021/html/Mayer_Learning_Target_Candidate_Association_To_Keep_Track_of_What_Not_ICCV_2021_paper.html)  
  基于SuperDiMP, 提出可学习的目标候选关联网络，用于显示关联distractor。
* STARK: "Learning Spatio-Temporal Transformer for Visual Tracking" ICCV. [[Paper]](http://openaccess.thecvf.com/content/ICCV2021/html/Yan_Learning_Spatio-Temporal_Transformer_for_Visual_Tracking_ICCV_2021_paper.html)  
  不同与常规的transformer结构，参照目标检测的DETR. 
* "Alpha-Refine: Boosting Tracking Performance by Precise Bounding Box Estimation" CVPR. [[Paper]](http://openaccess.thecvf.com/content/CVPR2021/html/Yan_Alpha-Refine_Boosting_Tracking_Performance_by_Precise_Bounding_Box_Estimation_CVPR_2021_paper.html)  
   一个即插即用的涨分组件，采用孪生网络架构，主要包括corner和mask分支，在基础跟踪器结构基础上进一步提炼目标框。特征融合是pixel-wise互相关。
* TranT: "Transformer Tracking" CVPR. [[Paper]](http://openaccess.thecvf.com/content/CVPR2021/html/Chen_Transformer_Tracking_CVPR_2021_paper.html)  
  孪生跟踪器，采用Transformer结构融合模板和搜索区域特征。
* TrDiMP: "Transformer Meets Tracker: Exploiting Temporal Context for Robust Visual Tracking" CVPR. [[Paper]](http://openaccess.thecvf.com/content/CVPR2021/html/Wang_Transformer_Meets_Tracker_Exploiting_Temporal_Context_for_Robust_Visual_Tracking_CVPR_2021_paper.html)    
  基于DiMP, 采用Transformer结构融合多帧特征。
  
## 2020
* KYS: "Know Your Surroundings: Exploiting Scene Information for Object Tracking" ECCV. [[Paper]](https://link.springer.com/chapter/10.1007/978-3-030-58592-1_13)  
  基于DiMP,采用ConvGRU隐式编码场景信息以应对distractor的干扰
* LTMU: "High-Performance Long-Term Tracking With Meta-Updater" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2020/html/Dai_High-Performance_Long-Term_Tracking_With_Meta-Updater_CVPR_2020_paper.html)   
  Local+Global长期目标跟踪方式，局部跟踪器采用的ATOM定位+SiamMask尺度估计；fast R-CNN作为重检测器，SiamRPN用于对检测器的object并行生成更精准的矩形框，RTMDNet作为验证器重新识别目标供局部跟踪器继续跟踪。除了多跟踪器组合，核心是提出LSTM结构的Meta-Updater。
* PrDiMP: "Probabilistic Regression for Visual Tracking" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2020/html/Danelljan_Probabilistic_Regression_for_Visual_Tracking_CVPR_2020_paper.html)  
  满屏的公式，基于DiMP，从概率解释的角度构建回归模型，并采用KL散度训练。
* "D3S - A Discriminative Single Shot Segmentation Tracker" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2020/html/Lukezic_D3S_-_A_Discriminative_Single_Shot_Segmentation_Tracker_CVPR_2020_paper.html)  
  分割式跟踪，实现短期跟踪和视频目标分割，ATOM+VideoMatch+U-net组合。
* "Siam R-CNN: Visual Tracking by Re-Detection" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2020/html/Voigtlaender_Siam_R-CNN_Visual_Tracking_by_Re-Detection_CVPR_2020_paper.html)    
  长期跟踪，采用第一帧和前一帧目标重检测比对的方式，hard example mining提高判别能力，动态规划潜在目标和干扰者，现有的Box2Seg用于分割。总体跟踪速度太慢。
* "Globaltrack: A simple and strong baseline for long-term tracking" AAAI. [[Paper]](https://ojs.aaai.org/index.php/AAAI/article/view/6758)  
   全局搜索模型的长期目标跟踪任务，基于Faster-RCNN 类似于One-shot detector, 无模板更新。
* "SiamFC++: Towards Robust and Accurate Visual Tracking with Target Estimation Guidelines" AAAI. [[Paper]](https://ojs.aaai.org/index.php/AAAI/article/view/6944)  
   anchor-free的预测头（ltrb），计算一个中心度得分图对分类得分图加权，以降低离中心点远的位置得分值，提高鲁棒性。

## 2019
* DiMP: "Learning Discriminative Model Prediction for Tracking" ICCV. [[Paper]](http://openaccess.thecvf.com/content_ICCV_2019/html/Bhat_Learning_Discriminative_Model_Prediction_for_Tracking_ICCV_2019_paper.html) [[Code]](https://github.com/visionml/pytracking)   
  将相关滤波跟踪范式设计成端到端可训练的在线目标分类分支 
* "ATOM: Accurate Tracking by Overlap Maximization" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2019/html/Danelljan_ATOM_Accurate_Tracking_by_Overlap_Maximization_CVPR_2019_paper.html) [[Code]](https://github.com/visionml/pytracking)  
  将目标检测的IouNet引入到目标跟踪以解决目标尺度估计的问题
* "SiamRPN++: Evolution of Siamese Visual Tracking With Very Deep Networks" CVPR. [[Paper]](http://openaccess.thecvf.com/content_CVPR_2019/html/Li_SiamRPN_Evolution_of_Siamese_Visual_Tracking_With_Very_Deep_Networks_CVPR_2019_paper.html)    
  SiamRPN的改进版，采用ResNet50作为backbone，多层融合，以multi-channel方式融合模板和搜索区域（即，Depthwise Cross Correlation）
* "Learning the Model Update for Siamese Trackers" ICCV. [[Paper]](http://openaccess.thecvf.com/content_ICCV_2019/html/Zhang_Learning_the_Model_Update_for_Siamese_Trackers_ICCV_2019_paper.html)  
  针对Siamese trackers采用的固定或移动平均法方式更新目标模板，训练了一个UpdateNet解决孪生网络的模板更新问题。
    
## 2018
* UPDT: "Unveiling the Power of Deep Tracking" ECCV. [[Paper]](http://openaccess.thecvf.com/content_ECCV_2018/html/Goutam_Bhat_Unveiling_the_Power_ECCV_2018_paper.html)  
  将HOG+CN当作浅层特征，CNN特征当作深层特征，对两种特征响应图进行自适应权重融合。
* SiamRPN: "High Performance Visual Tracking with Siamese Region Proposal Network" CVPR. [[Paper]](http://openaccess.thecvf.com/content_cvpr_2018/html/Li_High_Performance_Visual_CVPR_2018_paper.html)  
  将目标检测的RPN网络引入到目标跟踪
* DaSiamRPN: "Distractor-aware siamese networks for visual object tracking" [[Paper]](http://openaccess.thecvf.com/content_ECCV_2018/html/Zheng_Zhu_Distractor-aware_Siamese_Networks_ECCV_2018_paper.html)  
  Local-to-Global搜索方式的长期目标跟踪方法, 主要对正负样本对进行数据处理以提高网络应对distractor的判别力。

## 2017
* ECO: "ECO: Efficient Convolution Operators for Tracking" CVPR. [[Paper]](https://arxiv.org/abs/1611.09224) [[Code]](https://github.com/martin-danelljan/ECO)   
  滤波器参数降维；高斯混合模型对样本集进行聚类，提高训练样本的多样性；间隔5帧更新模型。 
* fDSST: "Discriminative Scale Space Tracking" TPAMI. [[Paper]](https://ieeexplore.ieee.org/abstract/document/7569092) [[Code]](http://www.cvl.isy.liu.se/research/objrec/visualtracking/scalvistrack/fDSST_code.zip)   
  DSST提出了新颖可移植的尺度估计方法，单独的尺度滤波器，33个尺度因子. fDSST主要是解决增加尺度估计方法所带来的速度下降的问题，对特征和尺度维度进行PCA降维. 
* CSR-DCF: "Discriminative Correlation Filter with Channel and Spatial Reliability" CVPR. [[Paper]](http://openaccess.thecvf.com/content_cvpr_2017/html/Lukezic_Discriminative_Correlation_Filter_CVPR_2017_paper.html)   
  存在不规则形状和中空的物体，克服循环位移的搜索范围随意和矩形形状的假设限制，颜色直方图掩膜和通道加权。 
* BACF: "Learning Background-Aware Correlation Filters for Visual Tracking" ICCV. [[Paper]](http://openaccess.thecvf.com/content_iccv_2017/html/Galoogahi_Learning_Background-Aware_Correlation_ICCV_2017_paper.html)  
  基于HOG特征的背景感知相关滤波，采集所有的背景块代替循环前景块作为负样本训练一个滤波器；ADMM迭代优化和Sherman-Morrison公式进行模型更新，增广拉格朗日法求解目标函数。
* LMCF:"Large Margin Object Tracking with Circulant Feature Maps" CVPR. [[Paper]](http://openaccess.thecvf.com/content_cvpr_2017/html/Wang_Large_Margin_Object_CVPR_2017_paper.html)  
   SVM 与 CF 结合，多模式目标检测方法，提出APCE指标优化模型更新策略。 
* CFNet: "End-to-end Representation Learning for Correlation Filter based Tracking" CVPR. [[Paper]](http://openaccess.thecvf.com/content_cvpr_2017/html/Valmadre_End-To-End_Representation_Learning_CVPR_2017_paper.html) [[Code]](https://github.com/bertinetto/cfnet)   
  训练非对称的 Siamese network，将 CF 作为层嵌入网络，并在傅里叶域进行 back-propagation，以实现端到端的训练网络。

## 2016
* SiamFC: "Fully-Convolutional Siamese Networks for Object Tracking" ECCVW. [[Paper]](https://link.springer.com/chapter/10.1007/978-3-319-48881-3_56)  
  端到端的深度学习跟踪方法，首次将孪生网络引入目标跟踪，将目标跟踪任务看作模板匹配方式。 
  
* "Staple: Complementary Learners for Real-Time Tracking" CVPR.  
  提出了颜色直方图作为补充学习特征，增强跟踪效果
* MDnet: "Learning multi-domain convolutional neural networks for visual tracking" CVPR. [[Project]](http://cvlab.postech.ac.kr/research/mdnet/)   
  多域学习，CNN共享层+多分支全连接分类，将不同视频序列当成不同的域训练共享层获取通用特征表示，另外，hard negative mining被用于在线学习。
   
## 2015
* KCF: "High-Speed Tracking with Kernelized Correlation Filters" TPAMI. [[Paper]](https://ieeexplore.ieee.org/abstract/document/6870486/)   
  CSK的升级版，详细阐述了循环位移采样过程，和引入核机制，并证明了核化后对角化可行性，此外使用了HOG特征  
* SRDCF: "Learning Spatially Regularized Correlation Filters for Visual Tracking" ICCV. [[Paper]](https://www.cv-foundation.org/openaccess/content_iccv_2015/html/Danelljan_Learning_Spatially_Regularized_ICCV_2015_paper.html)  
  对滤波模板进行惩罚减少循环位移带来的边际效应
* HCFT: "Hierarchical Convolutional Features for Visual Tracking" ICCV. [[Paper]](https://www.cv-foundation.org/openaccess/content_iccv_2015/html/Ma_Hierarchical_Convolutional_Features_ICCV_2015_paper.html) [[Code]](https://github.com/jbhuang0604/CF2)  
  采用3层CNN特征层分别进行相关滤波跟踪，亮点是采用多层CNN特征取代HOG特征

## 2014 
* CN: "Adaptive Color Attributes for Real-Time Visual Tracking" CVPR (Oral). [[Paper]](http://openaccess.thecvf.com/content_cvpr_2014/html/Danelljan_Adaptive_Color_Attributes_2014_CVPR_paper.html) [[Code]](http://www.cvl.isy.liu.se/research/objrec/visualtracking/colvistrack/ColorTracking_code.zip)   
  将color names替换掉CSK的灰度特征，并使用了PCA对11维特征进行降维
* SAMF: "A Scale Adaptive Kernel Correlation Filter Tracker with Feature Integration" ECCVW. [[Paper]](https://link.springer.com/chapter/10.1007/978-3-319-16181-5_18)  
  将 HOG 特征和 CN 特征融合并采用了简单的多尺度方法
   
## 2012
* CSK: "Exploiting the Circulant Structure of Tracking-by-detection with Kernels" ECCV. [[Paper]](https://link.springer.com/chapter/10.1007/978-3-642-33765-9_50)  
  提出循环密集采样，仅仅使用了灰度特征 
   
## 2010
* MOSSE: "Visual Object Tracking using Adaptive Correlation Filters" ICCV. [[Paper]](https://ieeexplore.ieee.org/abstract/document/5539960/)  
  第一次将相关滤波引入目标跟踪，负样本采样不足和存在过拟合 
