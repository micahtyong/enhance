//
//  OnboardingVC.swift
//  Enhance
//
//  Created by Micah Yong on 5/4/19.
//  Copyright © 2019 Micah Yong. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController, UIScrollViewDelegate {
    
    let scrollView : UIScrollView = UIScrollView()
    let pageControl : UIPageControl = UIPageControl()
    
    var onboardingSlides : [OnboardingView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        createSlides()
        setupPageControl()
        setupScrollView()
        setupSlideScrollView(slides: onboardingSlides)
    }
    
    // Mark: - Step 1: Initialize OnboardingView slides
    
    func createSlides() {
        let slide1 : OnboardingView = OnboardingView()
        slide1.setToPage(1)
        
        let slide2 : OnboardingView = OnboardingView()
        slide2.setToPage(2)
        
        let slide3 : OnboardingView = OnboardingView()
        slide3.setToPage(3)
        
        self.onboardingSlides = [slide1, slide2, slide3]
    }
    
    // Mark: - Step 2: Setup Page Control
    
    func setupPageControl() {
        pageControl.numberOfPages = onboardingSlides.count
        pageControl.currentPage = 0
        pageControl.tintColor = Enhance.customOrange
        //        view.bringSubviewToFront(pageControl)
        
        self.view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
    }
    
    // Mark: - Step 3: Setup Scroll View
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        self.view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        setupSlideScrollView(slides: onboardingSlides)
    }
    
    func setupSlideScrollView(slides : [OnboardingView]) {
        for i in 0..<onboardingSlides.count {
            onboardingSlides[i].frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
            onboardingSlides[i].frame.size = self.scrollView.frame.size
            self.scrollView.addSubview(onboardingSlides[i])
//            onboardingSlides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(onboardingSlides.count), height: scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(changePage), for: UIControl.Event.valueChanged)
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

}

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        pageControl.currentPage = Int(pageIndex)
//
//        // horizontal
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//        /*
//         * below code scales the imageview on paging the scrollview
//         */
//        let percentOffset : CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//        let changePercent : CGFloat = 0.5
//
//        if(percentOffset.x > 0 && percentOffset.x <= changePercent) {
//
//            onboardingSlides[0].imageView.transform = CGAffineTransform(scaleX: (changePercent-percentOffset.x)/changePercent, y: (changePercent-percentOffset.x)/changePercent)
//            onboardingSlides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/changePercent, y: percentOffset.x/changePercent)
//
//        } else if(percentOffset.x > changePercent && percentOffset.x <= 1) {
//
//            onboardingSlides[1].imageView.transform = CGAffineTransform(scaleX: ((changePercent * 2)-percentOffset.x)/changePercent, y: ((changePercent * 2)-percentOffset.x)/changePercent)
//            onboardingSlides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/(changePercent * 2), y: percentOffset.x/(changePercent * 2))
//
//        }
//    }


