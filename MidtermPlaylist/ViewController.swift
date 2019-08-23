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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var songLikeList = [Bool]()
    
    var nextPage: String?
    
    var totalSongs = 0
    
    var tokenInfo: TokenInfo?
    
    var currentIndex = 0
    
    let topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.loadImage(urlString: "https://i.kfs.io/playlist/global/26541395v266/cropresize/600x600.jpg")
        return imageView
    }()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.registerCellWithNib(identifier: SongTableViewCell.identifier, bundle: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        
        view.addSubview(topImageView)
        
        tableView.contentInset = UIEdgeInsets(top: UIScreen.main.bounds.width, left: 0, bottom: 0, right: 0)
        
        playlistProvider.getToken { [weak self] result in
            switch result {
                
            case .success(let tokenInfo):
                self?.tokenInfo = tokenInfo
                self?.getPlaylistData()
                self?.getPlaylistData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPlaylistData() {
        
        guard let tokenInfo = tokenInfo else { return }
        
        playlistProvider.getPlaylist(accessToken: tokenInfo.accessToken, offset: nextPage) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let playList):
                
                var isLikeArray = [Bool]()
                for _ in playList.data.indices {
                    isLikeArray.append(false)
                }
                
                if strongSelf.songList.isEmpty {
                    strongSelf.songList = playList.data
                    strongSelf.songLikeList = isLikeArray
                } else {
                    strongSelf.songList = (playList.data + strongSelf.songList)
                    strongSelf.songLikeList = (isLikeArray + strongSelf.songLikeList)
                }
            
                strongSelf.nextPage = playList.paging.next
                strongSelf.totalSongs = playList.summary.total
            case .failure(_):
                print("Error")
            }
        }
    }
    


}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalSongs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath)
        
        guard let songCell = cell as? SongTableViewCell else { return cell }
        
        songCell.setupCell(name: songList[indexPath.row].name, imageString: songList[indexPath.row].album.images.first!.url, isLike: songLikeList[indexPath.row])
        
        songCell.handler = { [weak self] cell in
            
            let weakIndexPath = tableView.indexPath(for: cell)
            
            guard let strongSelf = self, let indexPath = weakIndexPath else { return }
            
            strongSelf.songLikeList[indexPath.row] = !strongSelf.songLikeList[indexPath.row]
            
            cell.updateIslike(isLike: strongSelf.songLikeList[indexPath.row])
        }
        
        return songCell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let screenIndex = Int(scrollView.contentOffset.y / scrollView.frame.height)
        
        if screenIndex > currentIndex && songList.count < totalSongs {
            getPlaylistData()
            currentIndex += 1
        }
        
        let imageHeight = UIScreen.main.bounds.size.width
        let y = imageHeight - (scrollView.contentOffset.y + imageHeight)
        let height = min(max(y, 0), 600)
        topImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0

        UIView.animate(withDuration: 0.25) {
            cell.alpha = 1
        }
        
    }

}

