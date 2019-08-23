//
//  ViewController.swift
//  MidtermPlaylist
//
//  Created by littlema on 2019/8/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let playlistProvider = PlaylistProvider()
    
    var songList = [Song]() {
        didSet {
            print("songList.count:\(songList.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var songLikeList = [Bool]() {
        didSet {
            print("songLikeList.count:\(songLikeList.count)")
        }
    }
    
    var nextPage: String? {
        didSet {
            print(nextPage)
        }
    }
    
    var total = 0 {
        didSet {
            print(total)
        }
    }
    
    var currentIndex = 0

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCellWithNib(identifier: SongTableViewCell.identifier, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlaylistData()
        getPlaylistData()
    }
    
    func getPlaylistData() {
        playlistProvider.getPlaylist(offset: nextPage) { [weak self] respones in
            
            guard let strongSelf = self else { return }
            
            switch respones {
            case .success(let playList):
                strongSelf.songList += playList.data
                
                var array = [Bool]()
                for _ in playList.data.indices {
                    array.append(false)
                }
                
                strongSelf.songLikeList += array
                strongSelf.nextPage = playList.paging.next
                strongSelf.total = playList.summary.total
            case .failure(_):
                print("Error")
            }
        }
    }
    
    func updateIsLikeButton(isLike: Bool, songCell: SongTableViewCell) {
        if isLike {
            songCell.likeButton.setImage(UIImage.asset(ImageAsset.heartFill), for: .normal)
        } else {
            songCell.likeButton.setImage(UIImage.asset(ImageAsset.heart), for: .normal)
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        guard let songCell = cell as? SongTableViewCell else { return cell }
        
        songCell.songImageView.loadImage(urlString: songList[indexPath.row].album.images.first!.url)
        songCell.songNameLabel.text = songList[indexPath.row].name
        updateIsLikeButton(isLike: songLikeList[indexPath.row], songCell: songCell)
        
        songCell.handler = { [weak self] cell in
            
            let weakIndexPath = tableView.indexPath(for: cell)
            
            guard let strongSelf = self, let indexPath = weakIndexPath else { return }
            
            strongSelf.songLikeList[indexPath.row] = !strongSelf.songLikeList[indexPath.row]
            
            strongSelf.updateIsLikeButton(isLike: strongSelf.songLikeList[indexPath.row], songCell: songCell)
        }
        
        return songCell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let screenIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        if screenIndex > currentIndex && songList.count < total {
            print(screenIndex)
            getPlaylistData()
            currentIndex += 1
        }
        
    }
    
}

