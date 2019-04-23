# VisualTracking

This repository includes relative trackers of SOT.

FSAKCF is my improved algorithm, which uses a fast scale adaptive estimation to solve the problem of target scale change.

Baseline
1)	MOSSE: "Visual Object Tracking using Adaptive Correlation Filters." ICCV (2010).
第一次将相关滤波引入目标跟踪，负样本采样不足和存在过拟合
2)	CSK: "Exploiting the Circulant Structure of Tracking-by-detection with Kernels." ECCV (2012).
提出循环密集采样，仅仅使用了灰度特征
3)	STC: "Fast Tracking via Spatio-Temporal Context Learning." ECCV (2014).
在贝叶斯框架下，并提出了一种新颖的尺度估计方法，实际实验效果不佳
4)	KCF/DCF: "High-Speed Tracking with Kernelized Correlation Filters." TPAMI (2015).
详细阐述了循环位移采样过程，和引入核机制，并证明了核化后对角化可行性
Color
1)	CN:"Adaptive Color Attributes for Real-Time Visual Tracking." CVPR (2014).
将 color names  替换掉 CSK 的灰度特征，并使用了 PCA 对 11 维特征进行降维。
2)	MOCA:"MC-HOG Correlation Tracking with Saliency Proposal." AAAI (2016).
3)	Staple: "Staple: Complementary Learners for Real-Time Tracking." CVPR (2016).
提出了颜色直方图作为补充学习特征增强跟踪效果
Scale
1)	DSST: "Accurate Scale Estimation for Robust Visual Tracking." BMVC (2014).
提出了新颖可移植的尺度估计方法，单独的尺度滤波器，33 个尺度因子
2)	fDSST: "Discriminative Scale Space Tracking." TPAMI (2017).
主要是解决增加尺度估计方法所带来的速度下降的问题，对特征和尺度维度进行 PCA
降维
3)	SAMF:"A Scale Adaptive Kernel Correlation Filter Tracker with Feature Integration." ECCV workshop (2014).
将 HOG 特征和 CN 特征合并使用和提出了多尺度方法
4)	SKCF:"Scalable Kernel Correlation Filter with Sparse Feature Integration." ICCV workshop (2015).
5)	KCFDP/KCFDPT:"Enable Scale and Aspect Ratio Adaptability in Visual Tracking with Detection Proposals." BMVC (2015).
edgBox 的应用
6)	IBCCF:"Integrating Boundary and Center Correlation Filters for Visual Tracking With Aspect Ratio Variation." ICCV workshop (2017).
尺度比例自适应，边界得到 1D CF，结合中心 2D CF，考虑近正交性，使用 ADMM 迭代优化。
Multi kernel & feature & template & task
1)	MKCF: "Multi-kernel Correlation Filter for Visual Tracking." ICCV (2015).
2)	CF+MT:"Multi-Template Scale Adaptive Kernelized Correlation Filters." ICCV workshop (2015).
3)	SCT: "Visual Tracking Using Attention-Modulated Disintegration and Integration." CVPR (2016).
4)	MvCFT: "A Multi-view Model for Visual Tracking via Correlation Filters." KNOSYS (2016).
5)	MCPF: "Multi-task Correlation Particle Filter for Robust Visual Tracking." CVPR (2017).

Part-based
 
1)	RPAC: "Real-time part-based visual tracking via adaptive correlation filters." CVPR (2015).
2)	RPAC+:"Part-based Tracking via Discriminative Correlation Filters." TCSVT (2016).
3)	RPT:"Reliable Patch Trackers: Robust Visual Tracking by Exploiting Reliable Patches." CVPR (2015).
4)	DPCF: "Deformable Part-based Tracking by Coupled Global and Local Correlation Filters." JVCIR (2016).
5)	DPT: "Deformable Parts Correlation Filters for Robust Visual Tracking." CVPR (2016).
6)	StructCF: "Structural Correlation Filter for Robust Visual Tracking." CVPR (2016).
7)	"Real-time Correlation Filter Tracking by Efficient Dense Belief Propagation with Structure Preserving." TMM (2016).
8)	LGCF:"Robust Visual Tracking via Local-Global Correlation Filter." AAAI (2017).
9)	DCCO: "DCCO: Towards Deformable Continuous Convolution Operators." arXiv (2017).
10)	SP-KCF: "Non-Rigid Object Tracking via Deformable Patches Using Shape-Preserved KCF and Level Sets." ICCV (2017).

Long-term
1)	LCT: "Long-term Correlation Tracking." CVPR (2015).
KNN 与随机厥分类器，作为重检测
2)	LCT+:"Adaptive Correlation Filters with Long-Term and Short-Term Memory for Object Tracking." IJCV (under review)
3)	MUSTer: "MUlti-Store Tracker (MUSTer): a Cognitive Psychology Inspired Approach to Object Tracking." CVPR (2015).
4)	CCT:"Collobarative Correlation Tracking." BMVC (2015).
尺度变化与模型漂移
i.	首先提出一种有效的在线 CUR 检测滤波器，通过保持长期对象表示的低秩对应， 其误差上界可以被有效地计算。
ii.	提出了一种新的协作相关跟踪器，通过多尺度核相关滤波器联合捕获目标外观，并利用所学的 CUR 滤波器开发长期目标表示
通过对整个历史过程中的目标表观数据近似原理设计检测器判断是否漂移（SVD 与
CUR 降维技术减少计算量）。非极大值抑制（NMS）
每隔 10 帧更新尺度，40 帧以后，整幅图 top-k(k 最大为 10)个最大值位置与当前位置目标的重叠率小于 0.05 认为遮挡
Response adaptation
1)	CF+AT: "Target Response Adaptation for Correlation Filter Tracking." ECCV (2016).
新的CF 框架：目标响应 y 的自适应：检测阶段不变，训练阶段设置 7 个位移样本，每个位移采样取（1，1）得值，去乘于原始高斯标签函数，并把最大值循环到左上角。
2)	RCF: "Real-Time Visual Tracking: Promoting the Robustness of Correlation Filter Learning." ECCV (2016).

3)	OCT-KCF:"Output Constraint Transfer for Kernelized Correlation Filter in Tracking." TSMC (2016).

4)	"Correlation Filter Learning Toward Peak Strength for Visual Tracking." TCYB (2017).
 
Training set adaptation
1)	SRDCFdecon: "Adaptive Decontamination of the Training Set: A Unified Formulation for Discriminative Visual Tracking." CVPR (2016).
2)	ECO: "ECO: Efficient Convolution Operators for Tracking." CVPR (2017).
滤波模板系数化，高斯混合模型分类，间隔 5 帧更新模型。
Bound effect
1)	SRDCF: "Learning Spatially Regularized Correlation Filters for Visual Tracking." ICCV (2015).
对滤波模板进行惩罚减少循环位移带来的边际效应
2)	CFLB: "Correlation Filters with Limited Boundaries." CVPR (2015).
实际样本代替循环位移样本，增广拉格朗日方法迭代优化，MOSSE 空域表达式。
3)	SWCF:"Spatial Windowing for Correlation Filter based Visual Tracking." ICIP (2016).
4)	CF+CA: "Context-Aware Correlation Filter Tracking." CVPR (2017).
新的 CF 框架：Sherman-Morrison 公式和共轭梯度下降（CGD）。目标标签为高斯函数 y,k 个背景标签为 0，采样策略：恒速 Kalman 滤波器进行采样或在上一帧位置上与目标不重叠的采样（论文使用的）。矩阵求逆的方法选择。
5)	CSR-DCF: "Discriminative Correlation Filter with Channel and Spatial Reliability." CVPR (2017).
存在不规则形状和中空的物体，克服循环位移的使得搜索范围随意和矩形形状的假设限制。颜色直方图掩膜和通道加权。
6)	MRCT: "Manifold Regularized Correlation Object Tracking." TNNLS (2017).
增加了两个背景 CF
7)	BACF: "Learning Background-Aware Correlation Filters for Visual Tracking." ICCV (2017). 基于HOG特征的背景感知相关滤波，采集所有的背景块代替循环前景块作为负样本训练一个滤波器；交替方向乘子法(ADMM)迭代优化和Sherman-Morrison公式进行模型更新。增广拉格朗日法求解目标函数。论文中进行了很多的实验

Continuous
1)		C-COT: "Beyond Correlation Filters: Learning Continuous Convolution Operators for Visual Tracking." ECCV (2016).
SVM
1)	SCF:"Learning Support Correlation Filters for Visual Tracking." arXiv (2016).
2)	LMCF:"Large Margin Object Tracking with Circulant Feature Maps." CVPR (2017).
svm 与 CF 结合，多模式目标检测方法，新的模型更新策略。
Deep Feature

1)	HCFT:"Hierarchical Convolutional Features for Visual Tracking." ICCV (2015)
Cov3,cov4,cov5 三层 CNN
2)	HCFT+:"When Correlation Filters Meet Convolutional Neural Networks for Visual Tracking." SPL (2016).
将相关滤波整合进 CNN 模型，激进地更新滤波器，保守更新 CNN 模型
3)	HCFTstar: "Robust Visual Tracking via Hierarchical Convolutional Features." arXiv (2017).
引进了 edgebox 处理尺度和作为 re-detection 机制。
4)	DeepSRDCF: "Convolutional Features for Correlation Filter Based Visual Tracking." ICCV
 
workshop (2015).
5)	HDT: "Hedged Deep Tracking." CVPR (2016).
将 CNN 不同层分别作为特征训练弱跟踪器，通过 hedge 算法生成强跟踪器。
6)	ACFN: "Attentional Correlation Filter Network for Adaptive Visual Tracking." CVPR (2017). 基于不同模块类型的组合，自适应选择最好的模块。将注意力机制引进相关滤波（Matlab 实现相关滤波网络和 TensorFlow 实现注意力网络,LSTM）,使用了 AtCF 与 KCF。考虑了目标纵横变化和漂移目标的延迟更新。
贡献：引入注意相关滤波器网络，允许动态目标的自适应跟踪；利用注意力网络将注意力转移到最佳候选模块，以及预测当前非活动模块的估计精度；扩大相关滤波覆盖目标漂移、模糊、遮挡、尺度变化和柔性纵横比的多样性；通过多个实验验证视觉跟踪的注意机制的鲁棒性和效率。
7)	CFNet: "End-to-end Representation Learning for Correlation Filter based Tracking." CVPR (2017).
训练非对称的 Siamese network(孪生神经网络)，将 CF 最为层嵌入网络，并在傅里叶域进行 back-propagation，以实现端到端的训练网络。
8)	DCFNet: "DCFNet: Discriminant Correlation Filters Network for Visual Tracking." arXiv (2017).
Siamese network,自动学习 DCF 的特征，轻量级的特征学习网络
9)	CFCF:"Good Features to Correlate for Visual Tracking." arXiv (2017).
学习一个全卷积网络；反向传播公式是基于广义链规则和傅立叶域中实信号的共轭对称性。把特征通道上的独立假设作为未来的研究。卷积特征的选择。
i.	使用 CNN，专门为基于相关滤波的目标跟踪算法学习特征表达方式；
ii.	基于目标跟踪问题设计损失函数，推导出如何在 CNN 学习过程中进行反向传播；
iii.	结合 DCF（模型学习方法）+CCOT（特征插值方法）+DSST（尺度估计方法）+CNN
（特征提取方法）。
10)	CREST: "CREST: Convolutional Residual Learning for Visual Tracking." ICCV (2017).
将特征提取响应图生成模型更新整合进神经网络进行端到端训练；在线更新：残差学习。原因：DCF 独立于特征提取，端到端训练较少，参数更新固定
11)	CFWCR: "Correlation Filters With Weighted Convolution Responses." ICCV workshop (2017).
基于ECO，多不同特征维度响应图加权，尺度估计最优实验。
Thoughts
设置 1 个正样本滤波器和数个负样本滤波器，根据不同的负样本训练得到的滤波器跟踪框和正样本滤波器的跟踪框的是否重叠判断是否存在遮挡
在确定目标位置后，在新位置上对目标进行轮廓提取，取轮廓的 x,y 方向上的最大最小值。从 HDT 与 CFWCR 中结合学习，
响应图变化情况调整期望输出
